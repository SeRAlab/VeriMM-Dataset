module simple_adder(
    input clk, rst,
    input [7:0] A, B,
    output reg [7:0] C
);

always @(posedge clk) begin
    if(rst) begin
        C <= 0;
    end else begin
        C <= A + B;
    end
end

endmodule