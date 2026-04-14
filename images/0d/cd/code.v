module i2c_controller(  
    input wire clk,  
    input wire reset,  
    input wire [7:0] data_in,  
    output reg sda,  
    output reg scl,  
    output reg ack  
);  
  
    reg [3:0] state;  
    reg [3:0] bit_count;  
  
    parameter START = 4'b0000,  
              DATA  = 4'b0001,  
              ACK   = 4'b0010,  
              STOP  = 4'b0011;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= START;  
            sda <= 1;  
            scl <= 1;  
            ack <= 0;  
            bit_count <= 0;  
        end else begin  
            case (state)  
                START: begin  
                    sda <= 0;  // Start condition  
                    scl <= 1;  
                    state <= DATA;  
                end  
                DATA: begin  
                    sda <= data_in[7 - bit_count];  // Send data bits  
                    bit_count <= bit_count + 1;  
                    if (bit_count == 8) begin  
                        state <= ACK;  
                        bit_count <= 0;  
                    end  
                end  
                ACK: begin  
                    ack <= 1;  // Acknowledge from slave  
                    sda <= 0;  
                    state <= STOP;  
                end  
                STOP: begin  
                    sda <= 1;  // Stop condition  
                    scl <= 1;  
                    state <= START;  
                end  
            endcase  
        end  
    end  
endmodule