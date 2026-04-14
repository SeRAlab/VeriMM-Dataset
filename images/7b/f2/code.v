module top_module(
    input reset,
    input clk,
    input valid,
    output reg [1:0] errors
);// Constants for error messages
    localparam error_invalid_port = 2'b00;
    localparam error_invalid_class = 2'b01;
    
    // State variables
    reg [1:0] current_error;
    
    // Synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            current_error <= 2'b00;
            errors <= 2'b00;
        end
    end
    
    // Error generation
    always @(posedge clk) begin
        if (valid) begin
            case (current_error)
                2'b00: begin // No error generated yet
                    current_error <= error_invalid_port;
                    errors <= {current_error, error_invalid_class};
                end
                2'b01: begin // First error generated
                    current_error <= error_invalid_class;
                    errors <= {error_invalid_port, current_error};
                end
                default: begin // Both errors generated
                    current_error <= 2'b00;
                    errors <= 2'b00;
                end
            endcase
        end
    end
    
endmodule