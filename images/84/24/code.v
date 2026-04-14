module top_module(
    input i_clk, // Input clock
    input i_reset, // Asynchronous reset
    input i_push, // Push signal
    input i_pop, // Pop signal
    input [31:0] i_data, // Input data
    output reg [31:0] o_data, // Output data
    output reg o_empty, // Empty signal
    output reg o_full // Full signal
);parameter F_WIDTH = 4;
parameter F_SIZE = 1 << F_WIDTH;
parameter F_MAX = 16; // max number of elements we want to store

reg [F_WIDTH-1:0] read_pos;
reg [F_WIDTH-1:0] write_pos;
reg [31:0] memory[F_SIZE -1 : 0];
reg [4:0] total_count; // the number of elements currently in the FIFO
reg [4:0] read_counter;
reg [4:0] write_counter;

// Update empty and full indicators whenever total_count changes
always @(*) begin
    total_count = write_counter - read_counter;
    o_empty = (total_count == 0);
    o_full = (total_count == F_MAX);
end

// Handle writes (push)
always @(posedge i_clk) begin
    if(i_reset) begin
        write_counter <= 0;
        write_pos <= 0;
    end
    else if(!o_full && i_push) begin
        memory[write_pos] <= i_data;
        write_pos <= write_pos + 1'b1;
        write_counter <= write_counter + 1'b1;
    end
end

// Handle reads (pop)
always @(posedge i_clk) begin
    if(i_reset) begin
        read_counter <= 0;
        read_pos <= 0;
    end
    else if(!o_empty && i_pop) begin
        o_data <= memory[read_pos];
        read_pos <= read_pos + 1'b1;
        read_counter <= read_counter + 1'b1;
    end
end

endmodule