module top_module(
    input clk,
    input en,
    input arst,
    input srst,
    input ldin,
    input vzin,
    input ldout,
    input vzout,
    output vdin,
    output [7:0] din,
    output lzout,
    output vdout,
    output reg [7:0] z  // Changed from wire to reg
);parameter DEPTH = 16;
    parameter WIDTH = 8;
    parameter ADDR_WIDTH = $clog2(DEPTH);

    reg [WIDTH-1:0] buffer [0:DEPTH-1];
    reg [ADDR_WIDTH-1:0] head;
    reg [ADDR_WIDTH-1:0] tail;
    reg [ADDR_WIDTH:0] count;

    assign vdin = vzin;
    assign lzout = (count == 0) ? 1'b1 : 1'b0;
    assign vdout = (count > 0) ? 1'b1 : 1'b0;

    always @(posedge clk) begin
        if (srst || arst) begin
            head <= 0;
            tail <= 0;
            count <= 0;
        end else if (en) begin
            if (ldin && vzin && count < DEPTH) begin
                buffer[head] <= din;
                head <= head + 1;
                count <= count + 1;
            end

            if (ldout && vzout && count > 0) begin
                z <= buffer[tail]; // z can now be assigned here
                tail <= tail + 1;
                count <= count - 1;
            end
        end
    end

endmodule