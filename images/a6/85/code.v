module up_down_counter (
    input clk,
    input sreset,
    input en,
    input mode,
    output reg [3:0] count);

    always @(posedge clk) begin
        if (sreset) begin
            count <= 4'b0000;
        end else if (en) begin
            if (mode) begin
                count <= count + 1;
            end else begin
                count <= count - 1;
            end
        end
    end
endmodule