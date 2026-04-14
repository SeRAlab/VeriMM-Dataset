module spi_master (  
    input wire clk,  
    input wire cs,  
    input wire mosi,  
    output reg miso,  
    output reg [7:0] data_out,  
    output reg data_ready  
);  
    reg [2:0] bit_count;  
    reg [7:0] shift_reg;  

    always @(posedge clk or negedge cs) begin  
        if (!cs) begin  
            bit_count <= 0;  
            data_ready <= 0;  
            shift_reg <= 0;  
        end else begin  
            if (bit_count < 8) begin  
                shift_reg <= {shift_reg[6:0], mosi};  
                bit_count <= bit_count + 1;  
            end else begin  
                data_out <= shift_reg;  
                miso <= shift_reg[7];  
                data_ready <= 1;  
                bit_count <= 0;  
            end  
        end  
    end  
endmodule