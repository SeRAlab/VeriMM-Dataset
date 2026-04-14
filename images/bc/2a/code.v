module johnson_counter (
    input clk,
    input rst,
    output reg [3:0] counter);

    always @(posedge clk) begin
        if (rst) begin
            counter <= 4'b0000;
        end else begin
            counter <= {~counter[0], counter[3:1]};
        end
    end
endmodule