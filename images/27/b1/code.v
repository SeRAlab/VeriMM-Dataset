module down_counter(
    input clk,
    input reset_n,
    input [3:0] initial_value,
    output reg [3:0] count
);
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            count <= initial_value;
        end else if (count > 0) begin
            count <= count - 1;
        end
    end
endmodule