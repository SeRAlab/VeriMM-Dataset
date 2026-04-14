module top_module(

input clk,
input reset_L,
input selector,
input [1:0] data_in0,
input [1:0] data_in1,

output reg [1:0] data_out
);reg [1:0] cable_conexion;







always @(*)

    begin

        if(selector == 0) begin
          cable_conexion = data_in0;
        end 

        else begin
            if (selector == 1)begin
              cable_conexion = data_in1;
            end 
        end 

    end 





always @ (posedge clk) begin

    if (reset_L == 1) begin
         data_out <= cable_conexion;
    end 

      else begin
          if (reset_L == 0) begin
          data_out <= 0;
          end 
      end 

 end 

endmodule