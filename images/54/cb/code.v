module top_module(
    input clk,
    input reset,
    output reg out
);reg [1:0] counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 0;
        counter <= 2'b00;
    end else begin
        counter <= counter + 1;
        if (counter == 2'b00 || counter == 2'b01) begin
            out <= 1;
        end else if (counter == 2'b10 || counter == 2'b11) begin
            out <= 0;
        end
    end
end

endmodule