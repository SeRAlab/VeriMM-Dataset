module i2c_controller (  
    input wire clk,  
    input wire start,  
    input wire [7:0] data_in,  
    output reg [7:0] data_out,  
    output reg stop  
);  
    reg [2:0] state;  
    parameter IDLE = 3'b000, START = 3'b001, TRANSMIT = 3'b010, STOP = 3'b011;  

    always @(posedge clk) begin  
        case (state)  
            IDLE: begin  
                stop <= 1'b0;  
                if (start)  
                    state <= START;  
            end  
            START: begin  
                data_out <= data_in;  
                state <= TRANSMIT;  
            end  
            TRANSMIT: begin  
                // Simulate transmitting data (in reality, this could be more complex)  
                state <= STOP;  
            end  
            STOP: begin  
                stop <= 1'b1;  
                state <= IDLE;  
            end  
            default: state <= IDLE;  
        endcase  
    end  
endmodule