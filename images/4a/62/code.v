module shift_register (
    input clk,
    input reset,
    input load,
    input [3:0] parallel_in,
    output reg [3:0] Q
);

always @(posedge clk or posedge reset) begin
    if (reset)
        Q <= 4'b0000;
    else if (load)
        Q <= parallel_in;
    else
        Q <= {Q[2:0], 1'b0};
end

endmodule