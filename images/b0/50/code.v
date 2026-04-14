module top_module(
    input clock,
    input reset,
    output reg clock_out
);reg [1:0] counter;
always @(posedge clock or posedge reset) begin
    if (reset) begin
        counter <= 2'b0;
        clock_out <= 1'b0;
    end else begin
        counter <= counter + 1;
        if (counter == 2'b10) begin
            counter <= 2'b0;
            clock_out <= ~clock_out;
        end
    end
end

endmodule