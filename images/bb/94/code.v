module top_module(
    input [3:0] in,

    output [6:0] out
);wire [2:0] MSB;
reg [3:0] LSB;



parameter ZERO =  7'b100_0000;
parameter ONE =   7'b111_1001;

always @(in) begin
    case (in)
        4'b0000: begin 
            LSB = ZERO[3:0];
            
        end
         default: begin
            LSB = ONE[3:0];
         end    
    endcase      
end



assign out = LSB;

endmodule