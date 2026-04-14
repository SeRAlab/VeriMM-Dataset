module fifo_64x16 (
    input clk,
    input reset,
    input read_enable,
    input write_enable,
    input [15:0] write_data,
    output reg [15:0] read_data,
    output reg empty,
    output reg full );

reg [15:0] memory [63:0];
reg [5:0] read_ptr, write_ptr;
reg [6:0] count;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        read_ptr <= 0;
        write_ptr <= 0;
        count <= 0;
        empty <= 1;
        full <= 0;
    end else begin
        if (write_enable && !full) begin
            memory[write_ptr] <= write_data;
            write_ptr <= write_ptr + 1;
            count <= count + 1;
        end
        if (read_enable && !empty) begin
            read_data <= memory[read_ptr];
            read_ptr <= read_ptr + 1;
            count <= count - 1;
        end
        empty <= (count == 0);
        full <= (count == 64);
    end
end

endmodule