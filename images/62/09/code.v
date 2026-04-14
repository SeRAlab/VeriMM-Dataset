module top_module(
    input clk,
    input reset,
    input [4:0] value,
    output reg [4:0] counterOut
    );always @ (posedge clk or posedge reset) begin
            if (reset == 1) begin
                counterOut <= value;
            end else begin
                if (counterOut != 5'b11111)
                    counterOut <= counterOut - 1;
                else
                    counterOut <= value; 
            end
        end
endmodule