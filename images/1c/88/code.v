module SPI_Controller (  
    input wire SCK,  
    input wire CS,  
    input wire MOSI,  
    output reg MISO  
);  
    reg [3:0] shift_reg;  
    integer bit_count;  

    always @(posedge SCK or negedge CS) begin  
        if (!CS) begin  
            bit_count <= 0;  
            shift_reg <= 4'b0000;  
        end else begin  
            if (bit_count < 4) begin  
                shift_reg <= {shift_reg[2:0], MOSI};  
                bit_count <= bit_count + 1;  
            end  
        end  
    end  

    always @(negedge SCK) begin  
        if (!CS) begin  
            MISO <= shift_reg[3];  
        end  
    end  
endmodule