module mpc_controller(
    input wire clk,
    input wire rst,
    input wire [3:0] current_state,
    input wire [3:0] input_signal,
    output reg [3:0] predicted_state
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        predicted_state <= 4'b0000;
    end else begin
        predicted_state <= current_state + input_signal;
    end
end

endmodule