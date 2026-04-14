module binary_counter (
    input clk,
    input clr,
    input en,
    output reg [2:0] count);

    always @(posedge clk) begin
        if (clr) begin
            count <= 3'b000;
        end else if (en) begin
            count <= count + 1;
        end
    end
endmodule