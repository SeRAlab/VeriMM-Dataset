module mpc_controller(
    input wire clk,
    input wire rst,
    input wire [3:0] state,
    output reg [3:0] control
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            control <= 4'b0000; // reset control signal
        end else begin
            if (state > 4'b1000) begin
                control <= state - 4'b0001; // Decrease state
            end else begin
                control <= state + 4'b0001; // Increase state
            end
        end
    end
endmodule