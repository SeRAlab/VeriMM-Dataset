module spi_master #(parameter DATA_WIDTH = 8) (  
    input wire clk,  
    input wire reset,  
    input wire start,  
    input wire [DATA_WIDTH-1:0] data_in,  
    input wire miso,  
    output reg sck,  
    output reg cs,  
    output reg [DATA_WIDTH-1:0] data_out,  
    output reg data_ready  
);  

    reg [3:0] bit_count;  
    reg [DATA_WIDTH-1:0] shift_reg;  
    reg sending;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            sck <= 0;  
            cs <= 1;  
            bit_count <= 0;  
            data_ready <= 0;  
            sending <= 0;  
        end else begin  
            if (start && !sending) begin  
                cs <= 0;  
                shift_reg <= data_in;  
                bit_count <= 0;  
                sending <= 1;  
                data_ready <= 0;  
            end  
            if (sending) begin  
                sck <= ~sck;  
                if (sck) begin  
                    data_out[bit_count] <= miso;  
                    if (bit_count < DATA_WIDTH-1) begin  
                        bit_count <= bit_count + 1;  
                        shift_reg <= {shift_reg[DATA_WIDTH-2:0], 1'b0};  
                    end else begin  
                        cs <= 1;  
                        data_ready <= 1;  
                        sending <= 0;  
                    end  
                end  
            end  
        end  
    end  
endmodule