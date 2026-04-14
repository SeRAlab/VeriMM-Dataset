module johnson_counter (
    input clk,
    input rst,
    input en,
    output reg [7:0] count);

    always @(posedge clk) begin
        if (rst) begin
            count <= 8'b0;
        end else if (en) begin
            count <= {~count[0], count[7:1]};
        end
    end
endmodule