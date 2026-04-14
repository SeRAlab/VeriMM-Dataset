module shift_register(
    input clk,
    input rst_n,
    input load,
    input [7:0] data_in,
    output reg [7:0] q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        q <= 8'b00000000; // reset register to 0
    else if (load)
        q <= data_in; // load data_in value
    else
        q <= {q[6:0], 1'b0}; // shift left by one bit
end

endmodule