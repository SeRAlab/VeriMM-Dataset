module I2C_Controller (  
    input wire clk,  
    input wire reset,  
    input wire start,  
    input wire stop,  
    input wire read,  
    input wire write,  
    input wire [7:0] data_in,  
    output reg SDA,  
    output reg SCL,  
    output reg done  
);  
    reg [3:0] state;  
    parameter IDLE = 4'b0000, START = 4'b0001, WRITE = 4'b0010, READ = 4'b0011, STOP = 4'b0100;  
    reg [2:0] bit_count;  
    reg [7:0] data_reg;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            SDA <= 1;  
            SCL <= 1;  
            done <= 0;  
            bit_count <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    done <= 0;  
                    if (start) begin  
                        SDA <= 0;  
                        state <= START;  
                    end  
                end  
                START: begin  
                    SCL <= 0;  
                    if (write) begin  
                        data_reg <= data_in;  
                        state <= WRITE;  
                    end else if (read) begin  
                        state <= READ;  
                    end  
                end  
                WRITE: begin  
                    SDA <= data_reg[7];  
                    SCL <= 1;  
                    #1;  
                    SCL <= 0;  
                    data_reg <= {data_reg[6:0], 1'b0};  
                    bit_count <= bit_count + 1;  
                    if (bit_count == 7) begin  
                        bit_count <= 0;  
                        state <= STOP;  
                    end  
                end  
                READ: begin  
                    SCL <= 1;  
                    SDA <= 1;  
                    #1;  
                    SCL <= 0;  
                    // Read data (dummy logic, actual needs to be implemented)  
                    bit_count <= bit_count + 1;  
                    if (bit_count == 7) begin  
                        bit_count <= 0;  
                        state <= STOP;  
                    end  
                end  
                STOP: begin  
                    SDA <= 1;  
                    SCL <= 1;  
                    done <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule