module top_module(
    input [3:0] in,
    input reset,
    output reg [3:0] out
);always @(*) begin
    if (reset) begin
        out <= 4'b0000; //reset output to 0
    end
    else begin
        out <= {in[1:0], 2'b00}; //shift left by 2 bits and set 2 LSBs to 0
    end
end

endmodule