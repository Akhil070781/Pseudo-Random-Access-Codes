`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.03.2024 20:36:21
// Design Name: 
// Module Name: psc
// Project Name: PSEUDO SEQUENCE GENERATORS
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//we have used reset bit as reproducible button
  module psc(input [8:0]seed,
              input[3:0]sequence_width,
              input clk,reproducible_button,
              output reg[8:0]sequence_code
               );
   //s1 and s2 are lfsr sequence generators            
   reg [8:0]s1,s2;
   wire [8:0]add;
   reg load,shift;
   reg state;
  //we have calculated permuted seed
   wire [8:0]permuted_seed;
   assign permuted_seed={seed[4],seed[6],seed[2],seed[3],seed[8],seed[7],seed[5],seed[0],seed[1]};
   //we have added two lfsr generated sequences
  
   assign add=s1+s2+sequence_width;
   // assigning output based on size of sequence required
   always @*
   begin
   sequence_code=9'b0;
   case(sequence_width)
   4'd0: sequence_code=9'b0;
   4'd1: sequence_code={8'b0,add[0]};
   4'd2: sequence_code={7'b0,add[1:0]};
   4'd3: sequence_code={6'b0,add[2:0]};
   4'd4: sequence_code={5'b0,add[3:0]};
   4'd5: sequence_code={4'b0,add[4:0]};
   4'd6: sequence_code={3'b0,add[5:0]};
   4'd7: sequence_code={2'b0,add[6:0]};
   4'd8: sequence_code={1'b0,add[7:0]};
   4'd9: sequence_code=add;
   default:sequence_code=9'b0;
   endcase
   end
   
 
  always @(posedge clk,posedge reproducible_button)
      begin               
           if(reproducible_button) begin s1<=9'b0; s2<=9'b0; end
                       
           else 
                 begin   
                                                                            
                  if(load) begin   s1<=seed;   s2<=permuted_seed;  end
                  if(shift) begin  s1<={s1[1]^s1[0],s1[8:1]};   s2<={s2[3]^s2[2],s2[8:1]};  end
                  
                  end 
                   
     end  
     
        //second always part for controller
  always @(posedge clk,posedge reproducible_button)              
              if(reproducible_button)   state<=1'b0;               
              else   state<=1'b1;    
              
              
              
              
  always @*
  begin
          load=1'b0;
          shift=1'b0;
                    case(state)
                       1'b0:load=1'b1;
                       1'b1:shift=1'b1; 
                       default:;                  
                    endcase   
       end    
       
       
                
  endmodule
