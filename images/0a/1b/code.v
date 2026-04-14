module mpc_controller(
    input wire clk,
    input wire rst,
    input wire [7:0] ref_input,  // Reference input
    input wire [7:0] state_input, // Current state input
    output reg [7:0] output_signal // Control output
);

    reg [7:0] error;
    reg [7:0] previous_output;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            output_signal <= 8'd0;
            previous_output <= 8'd0;
        end else begin
            error = ref_input - state_input; // Calculate error
            output_signal <= previous_output + error; // Update output
            previous_output <= output_signal; // Store previous output
        end
    end
endmodule