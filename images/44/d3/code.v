module top_module(
    input clk,
    input [2:0] shift_ctrl,
    input [7:0] data_in,
    output reg [7:0] data_out
);// Instantiate the 8-bit shift register
    reg [7:0] shift_reg;

    // Shift register logic
    always @(posedge clk) begin
        if (shift_ctrl[0]) begin // Shift enable
            if (shift_ctrl[1]) // Shift right
                shift_reg <= {1'b0, shift_reg[7:1]};
            else // Shift left
                shift_reg <= {shift_reg[6:0], 1'b0};
        end
        else begin
            shift_reg <= data_in; // Load data input
        end
    end

    // Instantiate the 2:1 multiplexer
    reg [7:0] mux_out;
    always @(*) begin
        if (shift_ctrl[2]) // Select between the two inputs
            mux_out = shift_reg; // Output the shifted value
        else
            mux_out = data_in; // Output the original data
    end
    
    // Assign the output
    always @(posedge clk) begin
        data_out <= mux_out;
    end
    
endmodule