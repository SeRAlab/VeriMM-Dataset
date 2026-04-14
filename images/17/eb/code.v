module clock_gating_counter (
    input wire clk,
    input wire enable,
    output reg [3:0] count
);
    always @(posedge clk) begin
        if (enable) begin
            count <= count + 1;
        end
    end
endmodule