module top_module(
    input active,
    input clk_x2,
    input [7:0] data,
    output reg [15:0] rgb // Changed to reg to allow assignment in always block
);// Registers for storing incoming data pairs
    reg [7:0] data_pair_0;
    reg [7:0] data_pair_1;
    
    // Register for storing the current data pair index
    reg [1:0] data_pair_index;
    
    // Register for storing the current RGB value
    reg [15:0] current_rgb;
    
    always @(posedge clk_x2) begin
        if (active) begin
            // Store incoming data pairs in registers
            case (data_pair_index)
                2'b00: data_pair_0 <= data;
                2'b01: data_pair_1 <= data;
            endcase
            
            // Increment data pair index
            data_pair_index <= data_pair_index + 1;
            
            if (data_pair_index == 2'b10) begin
                // Combine incoming data pairs to form RGB values
                current_rgb[15:8] <= data_pair_1;
                current_rgb[7:0] <= data_pair_0;
                
                // Output current RGB value
                rgb <= current_rgb;
                
                // Reset data pair index and RGB value
                data_pair_index <= 2'b00;
                current_rgb <= 16'h0000;
            end
        end
    end

endmodule