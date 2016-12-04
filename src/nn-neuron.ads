-----------------------------------------------------------------
--                                                             --
-- Neuron Specification                                        --
--                                                             --
-- Copyright (c) 2016, John Leimon                             --
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
with Ada.Containers.Indefinite_Vectors; use Ada.Containers;
with Ada.Numerics.Real_Arrays;          use Ada.Numerics.Real_Arrays;

package NN.Neuron is

   type Float_Array is array (Natural range <>) of Float;

   package Float_Vectors is new Indefinite_Vectors (Natural, Float);

   type Neuron_Type is record
      Bias          : Float;
      Input_Weights : Float_Vectors.Vector;
      Transfer      : Transfer_Function;
   end record;

   type Delay_Block is private;

   package Neuron_Layers is new Indefinite_Vectors (Natural, Neuron_Type);

   use Neuron_Layers;

   package Multi_Layer_Neural_Network is new Indefinite_Vectors(Natural, Neuron_Layers.Vector);

   function Create_Delay_Block (Initial_State : Float_Array) return Delay_Block;

   function Create_Layer (Number_Of_Inputs  : Natural;
                          Number_Of_Neurons : Natural;
                          Transfer          : Transfer_Function;
                          Input_Weight      : Float := 1.0;
                          Bias              : Float := 0.0) return Neuron_Layers.Vector;

   function Fire (Neuron : Neuron_Type;
                  Input  : Float_Array) return Float;
   function Fire (Layer  : Neuron_Layers.Vector;
                  Input  : Float_Array) return Float_Array;
   function Fire (Network : Multi_Layer_Neural_Network.Vector;
                  Input   : Float_Array) return Float_Array;
   procedure Fire (Block  : in out Delay_Block;
                   Input  : in     Float_Array;
                   Output : out    Float_Array);

private

   type Delay_Block is record
      Memory : Float_Vectors.Vector;
   end record;

end NN.Neuron;
