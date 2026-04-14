module temp_shutdown(
    input wire clk,
    input wire rst,
    input wire [7:0] temp,
    output reg shutdown
);

    parameter THRESHOLD = 8'd75;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shutdown <= 0;
        end else if (temp > THRESHOLD) begin
            shutdown <= 1;
        end else begin
            shutdown <= 0;
        end
    end
endmodule