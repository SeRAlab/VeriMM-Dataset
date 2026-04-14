module reset_controller #(parameter RESET_DURATION = 4) (
    input wire clk,
    input wire reset_n,
    output reg reset_out
);
    reg [3:0] counter;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            counter <= 0;
            reset_out <= 0;
        end else if (counter < RESET_DURATION) begin
            counter <= counter + 1;
            reset_out <= 0;
        end else begin
            reset_out <= 1;
        end
    end
endmodule