module divide_by_4 (
    input wire clk,
    input wire reset,
    output reg out
);
    reg [1:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 2'b00;
            out <= 1'b0;
        end else begin
            count <= count + 1;
            out <= (count == 2'b11) ? ~out : out; // Toggle output every 4 cycles
        end
    end
endmodule