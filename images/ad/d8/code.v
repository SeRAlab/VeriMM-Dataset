module top_module(
    input clk,
    input reset,
    input [WIDTH-1:0] data_in,
    input data_in_start,
    input data_in_end,
    output reg [WIDTH-1:0] data_out,
    output reg data_out_start,
    output reg data_out_end
);parameter WIDTH = 8;
parameter DEPTH = 12;

reg [WIDTH-1:0] buffer [0:DEPTH-1];
reg [DEPTH-1:0] read_ptr;
reg [DEPTH-1:0] write_ptr;
reg [WIDTH-1:0] tempdata;
reg tempstart;
reg tempend;
reg [DEPTH-1:0] count;

always @(posedge clk)
begin
    if (reset)
    begin
        read_ptr <= 0;
        write_ptr <= 0;
        count <= 0;
    end
    else
    begin
        if (data_in_start)
        begin
            buffer[write_ptr] <= data_in;
            write_ptr <= write_ptr + 1;
            count <= count + 1;
        end

        if (data_out_end && count > 0)
        begin
            data_out <= buffer[read_ptr];
            read_ptr <= read_ptr + 1;
            count <= count - 1;
        end
    end

    if (count == 0)
    begin
        data_out_start <= 0;
        data_out_end <= 1;
    end
    else if (count == DEPTH)
    begin
        data_out_start <= 1;
        data_out_end <= 0;
    end
    else
    begin
        data_out_start <= (read_ptr == 0);
        data_out_end <= (write_ptr == DEPTH-1);
    end
end

endmodule