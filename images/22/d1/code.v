module fifo_buffer (
    input clk,
    input rst,
    input push,
    input pop,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg full,
    output reg empty
);
    parameter SIZE = 4; // Example size of FIFO
    reg [7:0] buffer [0:SIZE-1];
    reg [1:0] write_pointer;
    reg [1:0] read_pointer;
    reg [2:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            write_pointer <= 0;
            read_pointer <= 0;
            count <= 0;
            full <= 0;
            empty <= 1;
        end else begin
            if (push && !full) begin
                buffer[write_pointer] <= data_in;
                write_pointer <= (write_pointer + 1) % SIZE;
                count <= count + 1;
            end
            if (pop && !empty) begin
                data_out <= buffer[read_pointer];
                read_pointer <= (read_pointer + 1) % SIZE;
                count <= count - 1;
            end
            full <= (count == SIZE);
            empty <= (count == 0);
        end
    end
endmodule