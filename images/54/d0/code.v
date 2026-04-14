module ring_counter (
    input clk,
    input sreset,
    input en,
    output reg [2:0] count);

    always @(posedge clk) begin
        if (sreset) begin
            count <= 3'b001;
        end else if (en) begin
            count <= {count[1:0], count[2]};
        end
    end
endmodule