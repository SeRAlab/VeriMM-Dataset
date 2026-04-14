module top_module(
    input clk,
    input resetn,
    input [7:0] din,
    output [7:0] dout,
    input shift_in,
    input shift_out,
    output reg [7:0] used_slots,
    output reg [7:0] free_slots
);reg [7:0] memory [0:255];
    reg [7:0] wptr, rptr;
    reg [7:0] memory_dout;
    reg [7:0] pass_dout;
    reg use_pass_dout;
    assign dout = use_pass_dout ? pass_dout : memory_dout;
    wire do_shift_in = shift_in && |free_slots;
    wire do_shift_out = shift_out && |used_slots;

    always @(posedge clk) begin
        if (!resetn) begin
            wptr <= 0;
            rptr <= 0;
            used_slots <= 0;
            free_slots <= 255;
        end else begin
            // Write data to memory array if shift_in is asserted and there are free slots
            if (do_shift_in) begin
                memory[wptr] <= din;
                wptr <= wptr + 1;
                used_slots <= used_slots + 1;
                free_slots <= free_slots - 1;
            end

            // Read data from memory array if shift_out is asserted and there are used slots
            if (do_shift_out) begin
                memory_dout <= memory[rptr];
                rptr <= rptr + 1;
                used_slots <= used_slots - 1;
                free_slots <= free_slots + 1;
            end

            // Pass input data to output if FIFO buffer is empty
            if (use_pass_dout) begin
                pass_dout <= din;
            end

            // Update use_pass_dout signal if FIFO buffer is emptied or filled
            use_pass_dout <= wptr == rptr && !do_shift_in;
        end
    end
endmodule