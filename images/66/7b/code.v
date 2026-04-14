module fifo (
    input clk,
    input reset,
    input write_enable,
    input read_enable,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg full,
    output reg empty
);
reg [7:0] mem [0:15];
reg [3:0] write_ptr, read_ptr, count;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        write_ptr <= 0;
        read_ptr <= 0;
        count <= 0;
        full <= 0;
        empty <= 1;
    end else begin
        if (write_enable && !full) begin
            mem[write_ptr] <= data_in;
            write_ptr <= write_ptr + 1;
            count <= count + 1;
        end
        if (read_enable && !empty) begin
            data_out <= mem[read_ptr];
            read_ptr <= read_ptr + 1;
            count <= count - 1;
        end
        full <= (count == 16);
        empty <= (count == 0);
    end
end

endmodule