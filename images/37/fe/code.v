module spi_controller (  
    input wire clk,  
    input wire cs,  
    input wire [7:0] data_in,  
    output reg [7:0] data_out,  
    output reg data_valid  
);  
    reg [2:0] bit_count;  
    reg [7:0] shift_reg;  
    
    always @(posedge clk or negedge cs) begin  
        if (!cs) begin  
            // Reset on chip select low  
            bit_count <= 0;  
            shift_reg <= 0;  
            data_valid <= 0;  
        end else begin  
            if (bit_count < 8) begin  
                // Shift in data on each clock cycle  
                shift_reg <= {shift_reg[6:0], data_in[7-bit_count]};  
                bit_count <= bit_count + 1;  
            end else begin  
                // Transmission complete  
                data_out <= shift_reg;  
                data_valid <= 1;  
            end  
        end  
    end  
endmodule