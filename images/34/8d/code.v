module spi_master(  
    input wire clk,  
    input wire rst,  
    input wire [7:0] data_in,  
    input wire start,  
    output reg mosi,  
    output reg sck,  
    output reg cs,  
    input wire miso,  
    output reg [7:0] data_out  
);  
    reg [2:0] state;  
    reg [3:0] bit_count;  
    reg [7:0] shift_reg;  

    localparam IDLE = 3'b000,  
               SEND = 3'b001,  
               WAIT = 3'b010;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            sck <= 0;  
            cs <= 1;  
            bit_count <= 0;  
            mosi <= 0;  
            data_out <= 8'b0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        cs <= 0;  
                        shift_reg <= data_in;  
                        bit_count <= 0;  
                        state <= SEND;  
                    end  
                end  
                SEND: begin  
                    if (bit_count < 8) begin  
                        mosi <= shift_reg[7];  
                        sck <= 1;  
                        state <= WAIT;  
                    end else begin  
                        cs <= 1;  
                        state <= IDLE;  
                    end  
                end  
                WAIT: begin  
                    sck <= 0;  
                    shift_reg <= {shift_reg[6:0], miso};  
                    bit_count <= bit_count + 1;  
                    data_out <= shift_reg;  
                    state <= SEND;  
                end  
            endcase  
        end  
    end  
endmodule