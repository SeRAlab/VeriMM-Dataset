module spi_master (  
    input wire clk,  
    input wire reset,  
    input wire start,  
    input wire [7:0] data_in,  
    output reg SCK,  
    output reg MOSI,  
    input wire MISO,  
    output reg CS,  
    output reg [7:0] data_out  
);  

    reg [2:0] state;  
    reg [2:0] bit_cnt;  
    reg [7:0] shift_reg;  

    parameter IDLE = 3'b000,  
              START = 3'b001,  
              SHIFT = 3'b010,  
              DONE = 3'b011;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            SCK <= 0;  
            CS <= 1;  
            bit_cnt <= 0;  
            data_out <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    CS <= 1;  
                    if (start) begin  
                        CS <= 0;  
                        shift_reg <= data_in;  
                        state <= START;  
                        bit_cnt <= 0;  
                    end  
                end  
                START: begin  
                    SCK <= 0;  
                    state <= SHIFT;  
                end  
                SHIFT: begin  
                    if (bit_cnt < 8) begin  
                        SCK <= ~SCK;  
                        if (SCK) begin  
                            MOSI <= shift_reg[7];  
                            shift_reg <= {shift_reg[6:0], MISO};  
                            bit_cnt <= bit_cnt + 1;  
                        end  
                    end else begin  
                        state <= DONE;  
                    end  
                end  
                DONE: begin  
                    SCK <= 0;  
                    CS <= 1;  
                    data_out <= shift_reg;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule