module mpc_controller (
    input wire clk,
    input wire rst,
    input wire [7:0] current_input,
    output reg [7:0] predicted_output
);
    reg [7:0] input_history [1:0]; // To store 2-step history

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            input_history[0] <= 8'b0;
            input_history[1] <= 8'b0;
            predicted_output <= 8'b0;
        end else begin
            // Update history
            input_history[1] <= input_history[0];
            input_history[0] <= current_input;
            // Simple prediction: average of the last two inputs
            predicted_output <= (input_history[0] + input_history[1]) >> 1;
        end
    end
endmodule