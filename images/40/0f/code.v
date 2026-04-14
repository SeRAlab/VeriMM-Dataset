module spi_controller(  
    input wire clk,  
    input wire reset,  
    input wire start,  
    input wire [3:0] data_in,  
    input wire MISO,  
    output reg [3:0] data_out,  
    output reg MOSI  
);  
    reg [2:0] bit_count;  
    reg [3:0] shift_reg;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            bit_count <= 3'b000;  
            data_out <= 4'b0000;  
            MOSI <= 1'b0;  
            shift_reg <= 4'b0000;  
        end else if (start) begin  
            shift_reg <= data_in;  
            bit_count <= 3'b000;  
        end else if (bit_count < 3'b100) begin  
            MOSI <= shift_reg[3];  
            data_out <= {data_out[2:0], MISO};  
            shift_reg <= {shift_reg[2:0], 1'b0};  
            bit_count <= bit_count + 1;  
        end  
    end  
endmodule