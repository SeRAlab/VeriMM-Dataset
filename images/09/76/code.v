module i2c_master (  
    input wire clk,  
    input wire start,  
    input wire [7:0] data_in,  
    output reg sda,  
    output reg scl  
);  
    reg [3:0] state;  
    reg [7:0] data;  
    reg [2:0] bit_cnt;  

    localparam IDLE = 4'b0000,  
               START = 4'b0001,  
               SEND = 4'b0010,  
               STOP = 4'b0011;  

    always @(posedge clk) begin  
        case (state)  
            IDLE: begin  
                if (start) begin  
                    data <= data_in;  
                    sda <= 0; // Start condition  
                    state <= START;  
                    scl <= 0;  
                end  
            end  
            START: begin  
                scl <= 0;  
                state <= SEND;  
                bit_cnt <= 7;  
            end  
            SEND: begin  
                sda <= data[bit_cnt];  
                scl <= 1;  
                #1;  
                scl <= 0;  
                if (bit_cnt == 0) begin  
                    state <= STOP;  
                end else begin  
                    bit_cnt <= bit_cnt - 1;  
                end  
            end  
            STOP: begin  
                sda <= 1; // Stop condition  
                state <= IDLE;  
            end  
        endcase  
    end  
endmodule