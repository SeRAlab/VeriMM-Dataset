module temp_shutdown(
    input wire clk,
    input wire rst,
    input wire [7:0] temp,
    output reg shutdown
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shutdown <= 0;
        end else if (temp > 8'd75) begin
            shutdown <= 1;
        end
    end
endmodule