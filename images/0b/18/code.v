module mpc_controller (
    input wire clk,
    input wire reset,
    input wire [7:0] setpoint,
    input wire [7:0] y,
    output reg [7:0] u
);
    reg [7:0] prev_u; // Previous control action
    reg signed [8:0] error; // Signed error calculation

    parameter MAX_U = 8'd255; // Maximum control output
    parameter MIN_U = 8'd0;   // Minimum control output
    parameter KP = 8'd2;      // Proportional gain

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            u <= 8'd0;
            prev_u <= 8'd0;
        end else begin
            error = setpoint - y; // Calculate error
            prev_u = u;            // Store previous control action
            
            // Calculate control action
            u = prev_u + (KP * error[7:0]);
            // Constrain u within limits
            if (u > MAX_U)
                u <= MAX_U;
            else if (u < MIN_U)
                u <= MIN_U;
        end
    end
endmodule