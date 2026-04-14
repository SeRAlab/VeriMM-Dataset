module top_module(
    input write_flag,
    input read_flag,
    input [7:0] data_in,
    input clock,
    input reset,
    output reg [7:0] data_out,
    output wire empty_flag,
    output wire full_flag
);reg [7:0] memory [3:0];
reg [1:0] write_pointer;
reg [1:0] read_pointer;
reg [1:0] next_write_pointer; // Change to reg type
reg [1:0] next_read_pointer;  // Change to reg type

assign empty_flag = (write_pointer == read_pointer);
assign full_flag = ((next_write_pointer == read_pointer) && (write_pointer == next_read_pointer));

always @(posedge clock or posedge reset) begin
    if (reset) begin
        write_pointer <= 2'b0;
        read_pointer <= 2'b0;
    end
    else begin
        write_pointer <= next_write_pointer;
        read_pointer <= next_read_pointer;
    end
end

always @(*) begin
    next_write_pointer = write_pointer;
    next_read_pointer = read_pointer;

    if (write_flag && !full_flag) begin
        memory[write_pointer] <= data_in;
        next_write_pointer = write_pointer + 2'b01;
    end

    if (read_flag && !empty_flag) begin
        data_out <= memory[read_pointer];
        next_read_pointer = read_pointer + 2'b01;
    end
end

endmodule