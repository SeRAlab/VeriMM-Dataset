module up_down_counter (
    input clk,
    input sreset,
    input en,
    input dir,
    output reg [5:0] count);

    always @(posedge clk) begin
        if (sreset) begin
            count <= 6'b000000;
        end else if (en) begin
            if (dir) begin
                count <= count + 1;
            end else begin
                count <= count - 1;
            end
        end
    end
endmodule