module VCO (
    input wire clk,
    input wire reset,
    input wire [3:0] ctrl,
    output reg out
);
    reg [3:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            out <= 0;
        end else begin
            count <= count + 1;
            if (count >= (15 - ctrl)) begin
                out <= ~out;
                count <= 0;
            end
        end
    end
endmodule