module shift_register(    
    input clk,
    input rst_n,
    input mode,
    input [3:0] parallel_in,
    input serial_in,
    output reg [3:0] q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        q <= 4'b0000; // reset to 0
    else if (mode == 1'b0)
        q <= parallel_in; // parallel load
    else
        q <= {serial_in, q[3:1]}; // serial shift right
end

endmodule