module top_module(
    input clk,
    input reset,   // Synchronous active-high reset
    input [3:1] ena,
    output reg [11:0] q
);reg [3:0] bcd_count;
reg [7:0] binary_count;

always @(posedge clk) begin
    if (reset) begin
        bcd_count <= 0;
        binary_count <= 0;
    end else begin
        if (ena) begin
            if (bcd_count == 999) begin
                bcd_count <= 0;
                binary_count <= binary_count + 1;
            end else begin
                bcd_count <= bcd_count + 1;
            end
        end else begin
            binary_count <= binary_count + 1;
        end
    end
end

assign q = {bcd_count, binary_count};

endmodule