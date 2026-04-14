module temperature_shutdown (
    input wire clk,
    input wire rst_n,
    input wire [3:0] temp_in,
    output reg shutdown
);

    parameter THRESHOLD = 4'd12;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shutdown <= 1'b0;
        end else if (temp_in > THRESHOLD) begin
            shutdown <= 1'b1;
        end else begin
            shutdown <= 1'b0;
        end
    end

endmodule