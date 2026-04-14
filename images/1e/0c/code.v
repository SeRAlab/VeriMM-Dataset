module i2c_controller(  
    input wire clk,  
    input wire rst,  
    input wire start,  
    input wire data_in,  
    output reg data_out,  
    output reg ack  
);  

reg [2:0] state;  
reg [7:0] data_buffer;  
reg [3:0] bit_count;  

localparam IDLE = 3'b000,  
           START = 3'b001,  
           READ = 3'b010,  
           ACK = 3'b011,  
           STOP = 3'b100;  

always @(posedge clk or posedge rst) begin  
    if (rst) begin  
        state <= IDLE;  
        bit_count <= 0;  
        data_out <= 0;  
        ack <= 0;  
    end else begin  
        case (state)  
            IDLE: begin  
                if (start) begin  
                    state <= START;  
                end  
            end  
            START: begin  
                data_out <= 1; // Generate start condition  
                state <= READ;  
            end  
            READ: begin  
                if (bit_count < 8) begin  
                    data_buffer[bit_count] <= data_in;  
                    bit_count <= bit_count + 1;  
                end else begin  
                    state <= ACK;  
                end  
            end  
            ACK: begin  
                ack <= 1;  
                state <= STOP;  
            end  
            STOP: begin  
                data_out <= 0; // Generate stop condition  
                ack <= 0;  
                state <= IDLE;  
                bit_count <= 0;  
            end  
        endcase  
    end  
end  
endmodule