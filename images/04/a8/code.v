module i2c_master (  
    input wire clk,  
    input wire go,  
    input wire [7:0] data_in,  
    output reg SDA,  
    output reg SCL  
);  
    reg [3:0] state;  
    reg [7:0] data;  
    reg [2:0] bit_index;  

    parameter IDLE = 0, START = 1, SEND = 2, STOP = 3;  

    always @(posedge clk) begin  
        case (state)  
            IDLE: begin  
                SDA <= 1;  
                SCL <= 1;  
                if (go) begin  
                    data <= data_in;  
                    state <= START;  
                end  
            end  
            START: begin  
                SDA <= 0;  
                state <= SEND;  
            end  
            SEND: begin  
                if (bit_index < 8) begin  
                    SDA <= data[7 - bit_index];  
                    SCL <= 0;  
                    SCL <= 1;  
                    bit_index <= bit_index + 1;  
                end else begin  
                    SCL <= 0;  
                    state <= STOP;  
                end  
            end  
            STOP: begin  
                SDA <= 1;  
                state <= IDLE;  
                bit_index <= 0;  
            end  
        endcase  
    end  
endmodule