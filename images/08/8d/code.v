module frequency_divider (
    input wire clk,
    input wire rst,
    output reg out
);
    reg [1:0] counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 2'b00;
            out <= 0;
        end else begin
            counter <= counter + 1;
            if (counter == 2'b11) begin
                out <= ~out; // toggle output every 4 clock cycles
            end
        end
    end
endmodule