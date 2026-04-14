module top_module(
    input clk,
    input d,
    output reg [2:0] shift_register_out,
    output reg q
);reg [2:0] shift_register;
reg [2:0] shift_register_next;

always @(posedge clk) begin
    shift_register_next[0] = shift_register[1];
    shift_register_next[1] = shift_register[2];
    shift_register_next[2] = shift_register[0] ^ shift_register[2];
    shift_register <= shift_register_next;

    shift_register_out <= shift_register; // Change to non-blocking assignment
end

always @(posedge clk) begin
    q <= ~(d & clk); // Change nand behavior to a clocked assignment
end

endmodule