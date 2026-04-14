module shift_reg4bit(
    input clk,
    input load,
    input [3:0] data_in,
    
    output reg [3:0] q
);

always @(posedge clk) begin
    if (load)
        q <= data_in;
    else
        q <= {1'b0, q[3:1]};
end

endmodule