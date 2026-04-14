module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [7:0] in,
    input [99:0] data,
    output reg [7:0] out
);reg [99:0] shifted_data;
    reg [3:0] priority_encoder_out; // Changed to 4 bits since max value is 7
    
    // Priority Encoder
    always @(*) begin
        case (in)
            8'b10000000: priority_encoder_out = 7; 
            8'b01000000: priority_encoder_out = 6; 
            8'b00100000: priority_encoder_out = 5; 
            8'b00010000: priority_encoder_out = 4; 
            8'b00001000: priority_encoder_out = 3; 
            8'b00000100: priority_encoder_out = 2; 
            8'b00000010: priority_encoder_out = 1; 
            8'b00000001: priority_encoder_out = 0; 
            default: priority_encoder_out = 4'b0; // Default case for no inputs
        endcase
    end
    
    // Barrel Shifter
    always @(posedge clk) begin
        if (load) begin
            shifted_data <= data;
        end else begin
            case (ena)
                2'b00: shifted_data <= {shifted_data[98:0], shifted_data[99]};
                2'b01: shifted_data <= {shifted_data[97:0], shifted_data[99:98]};
                2'b10: shifted_data <= {shifted_data[99], shifted_data[98:0]};
                2'b11: shifted_data <= shifted_data;
            endcase
        end
    end
    
    // Output
    always @(posedge clk) begin
        if (load) begin
            out <= in;
        end else begin
            // Update the output calculation to avoid part selects with variables
            out <= shifted_data[99:92] >> priority_encoder_out; // Shift right instead of using indices
        end
    end
    
endmodule