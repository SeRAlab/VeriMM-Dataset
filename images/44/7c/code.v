module ring_counter (
    input clk,
    input rst,
    input en,
    output reg [11:0] counter);

    always @(posedge clk) begin
        if (rst) begin
            counter <= 12'b000000000001;
        end else if (en) begin
            counter <= {counter[10:0], counter[11]};
        end
    end
endmodule