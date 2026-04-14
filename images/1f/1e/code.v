module spi_controller(  
    input wire clk,  
    input wire cs_n,  
    input wire mosi,  
    output reg [7:0] miso,  
    output reg data_ready  
);  
    reg [7:0] shift_reg;  
    reg [2:0] bit_count;  

    always @(posedge clk or negedge cs_n) begin  
        if (!cs_n) begin  
            // Reset on CS low  
            bit_count <= 3'b000;  
            shift_reg <= 8'b00000000;  
            data_ready <= 1'b0;  
        end else begin  
            if (bit_count < 3'b111) begin  
                shift_reg <= {shift_reg[6:0], mosi};  
                bit_count <= bit_count + 1;  
            end else begin  
                data_ready <= 1'b1;  
                miso <= shift_reg;  
            end  
        end  
    end  
endmodule