-----------------------------------------------------------------
--                                                             --
-- Neuron                                                      --
--                                                             --
-- Copyright (c) 2016, John Leimon, Adam Schwem                --
--                                                             --
-- Permission to use, copy, modify, and/or distribute          --
-- this software for any purpose with or without fee           --
-- is hereby granted, provided that the above copyright        --
-- notice and this permission notice appear in all copies.     --
--                                                             --
-- THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR             --
-- DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE       --
-- INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY         --
-- AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE         --
-- FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL         --
-- DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS       --
-- OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF            --
-- CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING      --
-- OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF      --
-- THIS SOFTWARE.                                              --
-----------------------------------------------------------------
with Ada.Text_IO; use Ada.Text_IO;
with NN.Transfer; use NN.Transfer;
with NN.IO;       use NN.IO;

package body NN.Neuron is

   ------------------
   -- Create_Layer --
   ------------------

   function Create_Layer (Number_Of_Neurons : Natural;
                          Number_Of_Inputs  : Natural;
                          Transfer          : Transfer_Function;
                          Input_Weights     : Real_Matrix_Access;
                          Bias              : Float := 0.0) return Neural_Layer
   is
      Bias_Array     : Float_Array_Access := new Float_Array(Integer'First .. Integer'First + Number_Of_Neurons);
      Transfer_Array : Transfer_Function_Array_Access := new Transfer_Function_Array(Integer'First .. Integer'First + Number_Of_Neurons);
      Output         : Neural_Layer;
   begin

      Bias_Array.all     := (others => Bias);
      Transfer_Array.all := (others => Transfer);

      Output.Bias               := Bias_Array;
      Output.Weights            := Input_Weights;
      Output.Transfer_Functions := Transfer_Array;

      return Output;
   end Create_Layer;

   ------------------
   -- Delete_Layer --
   ------------------

   procedure Delete_Layer (Layer : in out Neural_Layer)
   is
   begin
      Free(Layer.Bias);
      Free(Layer.Weights);
      Free(Layer.Transfer_Functions);
   end Delete_Layer;

   ----------------------------
   -- Create_Hamming_Network --
   ----------------------------

   function Create_Hamming_Network (Number_Of_Neurons : Natural;
                                    Number_Of_Inputs  : Natural;
                                    Prototypes        : Real_Matrix_Access;
                                    Bias              : Float) return Hamming_Network
   is
      ε                       : constant := 0.5;
      Output                  : Hamming_Network;
      Recurrent_Input_Weights : Real_Matrix_Access := new Real_Matrix (Integer'First .. Integer'First + Number_Of_Neurons - 1,
                                                                       Integer'First .. Integer'First + Number_Of_Neurons - 1);
   begin

      -- Our recurrent input weights matrix for a 2 x 2 matrix --
      -- would be:                                             --
      --               |  1   -ε  |                            --
      --               | -ε    1  |                            --

      -- Build recurrent input weights matrix --
      for I in Recurrent_Input_Weights'Range(1) loop
         for J in Recurrent_Input_Weights'Range(2) loop
            if Abs(I - J) + 1 = Recurrent_Input_Weights'Length(1) then
               Recurrent_Input_Weights(I, J) := -ε;
            else
               Recurrent_Input_Weights(I, J) := 1.0;
            end if;
         end loop;
      end loop;

      Output.Feedforward := Create_Layer(Number_Of_Neurons,
                                         Number_Of_Inputs,
                                         Linear'Access,
                                         Prototypes,
                                         Bias);
      Output.Recurrent   := Create_Layer(Number_Of_Neurons,
                                         Number_Of_Inputs,
                                         Positive_Linear'Access,
                                         Recurrent_Input_Weights,
                                         Bias);

      return Output;

   end Create_Hamming_Network;

   ----------------------------
   -- Delete_Hamming_Network --
   ----------------------------

   procedure Delete_Hamming_Network (Network : in out Hamming_Network)
   is
   begin
      Delete_Layer(Network.Feedforward);
      Delete_Layer(Network.Recurrent);
   end Delete_Hamming_Network;

   ----------
   -- Fire --
   ----------

   procedure Fire (Layer  : in  Neural_Layer;
                   Input  : in  Real_Matrix;
                   Output : out Real_Matrix)
   is
      Weight             : Float;
      Sum                : Float; 
   begin

      for Neuron_Index in Layer.Weights'Range(1) loop
         Sum := 0.0;
         
         for Input_Index in Layer.Weights'Range(2) loop
            Weight := Layer.Weights(Neuron_Index, Input_Index);
            Sum    := Sum + Input(Input_Index, Integer'First) * Weight;
         end loop;

         Sum                                 := Sum + Layer.Bias(Neuron_Index); 
         Output(Neuron_Index, Integer'First) := Layer.Transfer_Functions(Neuron_Index)(Sum);
      end loop;
   end Fire;

   ----------
   -- Fire --
   ----------

   procedure Fire (Network : in  Neural_Network;
                   Input   : in  Real_Matrix;
                   Output  : out Real_Matrix)
   is
      Next_Input : Real_Matrix(1 .. 1, Input'First .. Input'Last);
   begin
      Next_Input := Input;
      for Layer in Network'Range loop
         Fire(Network(Layer), Next_Input, Output);
         Next_Input := Output;
      end loop;
   end Fire;

   ----------
   -- Fire --
   ----------

   procedure Fire (Network : in out Hamming_Network;
                   Input   : in     Real_Matrix;
                   Output  : out    Real_Matrix)
   is
      Feedforward_Output : Real_Matrix(Output'First .. Output'Last,
                                       Integer'First .. Integer'First);
   begin

      -- Feedforward layer --
      Fire(Network.Feedforward, Input, Feedforward_Output);

      -- Recurrent layer --
      loop
         Fire(Network.Recurrent, Feedforward_Output, Output);
         Feedforward_Output := Output;
         exit when Input = Feedforward_Output;
      end loop;
   end Fire;

end NN.Neuron;
