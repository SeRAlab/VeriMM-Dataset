module reset_controller(
    input wire clk,
    input wire rst_req,
    input wire [3:0] delay,
    output reg rst_out
);
    reg [3:0] counter;

    always @(posedge clk or posedge rst_req) begin
        if (rst_req) begin
            counter <= delay;
            rst_out <= 1'b1;
        end else if (counter > 0) begin
            counter <= counter - 1;
            rst_out <= 1'b1;
        end else begin
            rst_out <= 1'b0;
        end
    end
endmodule