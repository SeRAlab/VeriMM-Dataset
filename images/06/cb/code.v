module divide_by_8(
    input clk,
    input reset,
    output reg out
);
    reg [2:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 3'b000;
            out <= 1'b0;
        end else begin
            if (counter == 3'b111) begin
                out <= ~out; // Toggle output every 8 clock cycles
                counter <= 3'b000;
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule