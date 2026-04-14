module top_module(x, clk, rst, z            
    );input x, clk, rst;
output reg z;
parameter S0 = 0, S1 = 1;        
reg [0:1]  PS, NS;
always @ (posedge clk)       
if (rst) begin
    PS <= S0;       
    NS <= S0;       
   end
else begin
    PS <= NS;       
    end

always @(PS or x)   
    case (PS)
    S0 : begin                  
        z <= x;
        NS <= S1;              
        end
    S1 : begin
        z <= !x;               
        NS <= S1;
        end
    default: begin               
        NS <= S0;
        z <= 0;
        end
    endcase


endmodule