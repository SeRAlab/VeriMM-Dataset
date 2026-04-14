module seq_gen (
   input clk,
   output reg toggle
);

reg [3:0] counter = 0;

always @(posedge clk) begin
    counter <= counter + 1;
    if (counter == 10) begin
        toggle <= ~toggle;
        counter <= 0;
    end
end

endmodule