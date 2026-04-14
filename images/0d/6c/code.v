module i2c_controller(  
    input wire clk,  
    input wire start,  
    input wire [7:0] data,  
    output reg SDA,  
    output reg SCL  
);  
    reg [3:0] state;  
    reg [7:0] data_reg;  
    reg [2:0] bit_count;  

    parameter IDLE = 0, START = 1, SEND = 2, STOP = 3;  

    always @(posedge clk) begin  
        case (state)  
            IDLE: begin  
                SDA <= 1;  
                SCL <= 0;  
                if (start) begin  
                    state <= START;  
                end  
            end  
            START: begin  
                SDA <= 0;  
                state <= SEND;  
                bit_count <= 0;  
                data_reg <= data;  
            end  
            SEND: begin  
                SCL <= 0;  
                SDA <= data_reg[7 - bit_count];  
                if (bit_count < 7) begin  
                    bit_count <= bit_count + 1;  
                end else begin  
                    state <= STOP;  
                end  
                SCL <= 1;  
            end  
            STOP: begin  
                SCL <= 0;  
                SDA <= 1;  
                state <= IDLE;  
            end  
        endcase  
    end  
endmodule