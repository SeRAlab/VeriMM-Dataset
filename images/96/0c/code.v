module top_module(
    input clk,
    input rst_n,
    input we,
    input [7:0] din,
    output reg re,
    output reg [7:0] dout,
    output reg empty,
    output reg full
);parameter DEPTH = 16;
reg [7:0] mem [0:DEPTH-1];
reg [3:0] wptr = 0;
reg [3:0] rptr = 0;
reg [3:0] count = 0;

always @(posedge clk) begin
    if (!rst_n) begin
        wptr <= 0;
        rptr <= 0;
        count <= 0;
        re <= 0;
        dout <= 0;
        empty <= 1;
        full <= 0;
    end
    else begin
        if (we && !full) begin
            mem[wptr] <= din;
            wptr <= wptr + 1;
            count <= count + 1;
            if (wptr == DEPTH) begin
                wptr <= 0;
            end
        end
        if (re && !empty) begin
            dout <= mem[rptr];
            rptr <= rptr + 1;
            count <= count - 1;
            if (rptr == DEPTH) begin
                rptr <= 0;
            end
        end
        empty <= (count == 0);
        full <= (count == DEPTH);
    end
end

endmodule