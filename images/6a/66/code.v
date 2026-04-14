module ring_counter_4bit (
    input clk,
    input sreset,
    input en,
    output reg [3:0] count);

    always @(posedge clk) begin
        if (sreset) begin
            count <= 4'b0001;
        end else if (en) begin
            count <= {count[2:0], count[3]};
        end
    end
endmodule