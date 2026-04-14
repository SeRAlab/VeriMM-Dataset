module frequency_divider (
    input wire clk,
    input wire reset,
    output reg out_clk
);
    reg [1:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 2'b00;
            out_clk <= 1'b0;
        end else begin
            count <= count + 1;
            if (count == 2'b01) begin
                out_clk <= ~out_clk;
            end
        end
    end
endmodule