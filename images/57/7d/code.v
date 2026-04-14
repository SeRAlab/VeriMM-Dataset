module top_module(
    input wire clk,
    input wire reset,
    input wire up,
    output reg [3:0] counter
);

    always @(posedge clk) begin
        if (reset) begin
            counter <= 4'b0000;
        end else if (up) begin
            if (counter == 4'b1111) begin
                counter <= 4'b0000;
            end else begin
                counter <= counter + 1;
            end
        end else begin
            if (counter == 4'b0000) begin
                counter <= 4'b1111;
            end else begin
                counter <= counter - 1;
            end
        end
    end

endmodule