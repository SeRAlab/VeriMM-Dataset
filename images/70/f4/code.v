module top_module(
    input clk,
    input reset_n,
    input [WIDTH-1:0] din,
    output reg [WIDTH-1:0] dout  // Changed output from wire to reg
);parameter WIDTH = 8;
parameter DEPTH = 16;

reg [WIDTH-1:0] buffer [0:DEPTH-1];
reg [DEPTH-1:0] write_ptr = 0;
reg [DEPTH-1:0] read_ptr = 0;
reg empty = 1;
reg full = 0;

always @(posedge clk) begin
    if (!reset_n) begin
        write_ptr <= 0;
        read_ptr <= 0;
        empty <= 1;
        full <= 0;
    end else begin
        if (!full) begin
            buffer[write_ptr] <= din;
            write_ptr <= write_ptr + 1;
            if (write_ptr == DEPTH-1) begin  // Changed condition to DEPTH-1
                write_ptr <= 0;
            end
            empty <= 0;
            if (write_ptr == read_ptr) begin
                full <= 1;
            end
        end
    end
end

always @(posedge clk) begin
    if (!reset_n) begin
        dout <= 0;
    end else begin
        if (!empty) begin
            dout <= buffer[read_ptr];
            read_ptr <= read_ptr + 1;
            if (read_ptr == DEPTH-1) begin  // Changed condition to DEPTH-1
                read_ptr <= 0;
            end
            full <= 0;
            if (read_ptr == write_ptr) begin
                empty <= 1;
            end
        end
    end
end

endmodule