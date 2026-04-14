module top_module(
    input clk,                 // Clock for the rotator
    input load,                // Synchronous load for the rotator
    input [1:0] ena,           // Enable for the rotator
    input [99:0] data,         // Input data for the rotator
    input d,                   // Serial input for the shift register
    output reg [2:0] q         // Output from the functional module
);// Rotator module
    reg [99:0] rotator_out;
    always @(posedge clk) begin
        if (load) rotator_out <= data;
        else if (ena[1]) rotator_out <= {rotator_out[0], rotator_out[99:1]};
        else if (ena[0]) rotator_out <= {rotator_out[98:0], rotator_out[99]};
    end
    
    // Shift register module
    reg [2:0] shift_reg_out;
    reg [2:0] shift_reg_in;
    always @(posedge clk) begin
        shift_reg_in <= {shift_reg_in[1:0], d};
        shift_reg_out <= {shift_reg_out[1:0], shift_reg_in[2]};
    end
    
    // Functional module
    always @* begin
        q[0] = rotator_out[0] | shift_reg_out[0];
        q[1] = rotator_out[50] | shift_reg_out[1];
        q[2] = rotator_out[99] | shift_reg_out[2];
    end

endmodule