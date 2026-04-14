module spi_controller(  
    input wire clk,  
    input wire rst,  
    input wire [7:0] data_in,  
    input wire start,  
    output reg mosi,  
    output reg ready  
);  

    reg [2:0] bit_count;  
    reg [7:0] shift_reg;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            mosi <= 1'b0;  
            ready <= 1'b0;  
            bit_count <= 3'b000;  
            shift_reg <= 8'b00000000;  
        end else begin  
            if (start && !ready) begin  
                shift_reg <= data_in;  
                bit_count <= 3'b111;  
                ready <= 1'b1;  
            end else if (ready) begin  
                mosi <= shift_reg[bit_count];  
                if (bit_count > 0)  
                    bit_count <= bit_count - 1;  
                else  
                    ready <= 1'b0;  
            end  
        end  
    end  
endmodule