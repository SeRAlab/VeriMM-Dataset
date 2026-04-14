module top_module(
    input clock,
    input reset,
    output reg clock_out
);reg [1:0] count;

always @(posedge clock or posedge reset) begin
    if (reset) begin
        count <= 2'b00;
        clock_out <= 1'b0;
    end
    else begin
        count <= count + 1;
        if (count == 2'b01) begin
            clock_out <= ~clock_out;
        end
    end
end

endmodule