module top_module(
    input clk,
    input reset,
    output [3:1] ena,
    output reg [15:0] q // Changed 'output [15:0] q' to 'output reg [15:0] q'
);reg [3:0] count;
reg [3:1] bcd_count;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 0;
        bcd_count <= 0;
    end else begin
        count <= count + 1;
        if (count == 10) begin
            count <= 0;
            bcd_count <= bcd_count + 1;
        end
    end
end

assign ena = bcd_count[3:1];

always @* begin
    case (count)
        0: q = {4'b0000, bcd_count};
        1: q = {4'b0001, bcd_count};
        2: q = {4'b0010, bcd_count};
        3: q = {4'b0011, bcd_count};
        4: q = {4'b0100, bcd_count};
        5: q = {4'b0101, bcd_count};
        6: q = {4'b0110, bcd_count};
        7: q = {4'b0111, bcd_count};
        8: q = {4'b1000, bcd_count};
        9: q = {4'b1001, bcd_count};
        default: q = 16'b0;
    endcase
end

endmodule