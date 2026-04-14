module spi_controller(  
    input wire clk,  
    input wire reset,  
    input wire start,  
    input wire [7:0] data_in,  
    input wire ss,  
    output reg miso,  
    output reg sck,  
    output reg done  
);  

    reg [2:0] state;  
    reg [2:0] bit_cnt;  
    reg [7:0] shift_reg;  

    localparam IDLE = 3'b000;  
    localparam TRANSFER = 3'b001;  
    localparam SHIFT = 3'b010;  
    localparam DONE = 3'b011;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            bit_cnt <= 3'b000;  
            shift_reg <= 8'b00000000;  
            sck <= 0;  
            miso <= 0;  
            done <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (!ss && start) begin  
                        shift_reg <= data_in;  
                        state <= TRANSFER;  
                    end  
                    done <= 0;  
                end  
                TRANSFER: begin  
                    sck <= 1;  
                    state <= SHIFT;  
                end  
                SHIFT: begin  
                    miso <= shift_reg[7];  
                    shift_reg <= {shift_reg[6:0], 1'b0};  
                    bit_cnt <= bit_cnt + 1;  
                    if (bit_cnt == 3'b111) begin  
                        state <= DONE;  
                    end  
                end  
                DONE: begin  
                    sck <= 0;  
                    done <= 1;  
                    state <= IDLE;  
                    bit_cnt <= 3'b000;  
                end  
            endcase  
        end  
    end  
endmodule