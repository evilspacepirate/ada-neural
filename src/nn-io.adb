-----------------------------------------------------------------
--                                                             --
-- Input Output                                                --
--                                                             --
-- Copyright (c) 2016, 2017 John Leimon                        --
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
with Ada.Text_IO;
   use Ada.Text_IO;
with NN.Math;

package body NN.IO is

   use NN.Math.Super_Matrixes;

   ---------
   -- Put --
   ---------

   procedure Put
      (Input : Float_Array)
   is
   begin
      for I in Input'Range loop
         Put ("   ");
         Float_Text_IO.Put (Item => Input (I),
                            Fore =>  3,
                            Aft  => 24,
                            Exp  =>  0);
         New_Line;
      end loop;
   end Put;

   ---------
   -- Put --
   ---------

   procedure Put
     (Layer : Neural_Layer)
   is
   begin
      Put_Line ("Weights: ");
      Put (Layer.Weights.all);
      Put_Line ("Bias: ");
      Put (Layer.Bias.all);
   end Put;


   ---------
   -- Put --
   ---------

   procedure Put (Matrix : Real_Matrix)
   is
   begin
      for I in Matrix'Range (1) loop
         for J in Matrix'Range (2) loop
            Put ("   ");
            Float_Text_IO.Put (Item => Matrix (I, J),
                               Fore =>  3,
                               Aft  => 24,
                               Exp  =>  0);
         end loop;
         New_Line;
      end loop;
   end Put;

   ---------
   -- Put --
   ---------

   procedure Put (Matrix_Array : Real_Matrix_Access_Array)
   is
      Layer : Natural := 1;
   begin
      for I in Matrix_Array'Range loop
         Put_Line (Natural'Image(I) & ":");
         Put (Matrix_Array (I).all);
      end loop;
   end Put;

   --------------
   -- Put_Float --
   --------------

   procedure Put_Float (Input : Long_Long_Float)
   is
   begin
      Float_Text_IO.Put (Item => Input,
                         Fore =>  3,
                         Aft  => 24,
                         Exp  =>  0);
   end Put_Float;

end NN.IO;
