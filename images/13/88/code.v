module up_counter (
    input wire clk,
    input wire reset,
    input wire enable,
    output reg [1:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 2'b00;
        end else if (enable) begin
            count <= count + 1;
        end
    end
endmodule