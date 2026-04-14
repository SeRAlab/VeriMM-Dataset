module clk_counter(
    input clk,
    input reset,
    output reg [3:0] counter
);

always @(posedge clk, negedge reset) begin
    if(!reset) begin
        counter <= 4'b0000;
    end else begin
        counter <= counter + 1;
    end
end

endmodule