module top_module(
    input clk_in,
    output reg clk_out,
    input delay
);reg [31:0] counter;
reg delay_reached;

always @(posedge clk_in) begin
    if(delay_reached) begin
        counter <= 0;
        delay_reached <= 0;
        clk_out <= 1;
    end
    else if(counter == delay) begin
        delay_reached <= 1;
        clk_out <= 0;
    end
    else begin
        counter <= counter + 1;
        clk_out <= 1;
    end
end

endmodule