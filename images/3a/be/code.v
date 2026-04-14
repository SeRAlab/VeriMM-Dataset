module pcie_endpoint_controller(  
    input wire clk,  
    input wire rst_n,  
    input wire req,  
    input wire [31:0] addr,  
    output reg [31:0] data_out,  
    output reg ack  
);  
    reg [2:0] state;  
    parameter IDLE = 3'b000, DELAY = 3'b001, RESPOND = 3'b010;  
    parameter DELAY_CYCLES = 4;  
    reg [2:0] delay_counter;  
  
    always @(posedge clk or negedge rst_n) begin  
        if (!rst_n) begin  
            state <= IDLE;  
            ack <= 0;  
            data_out <= 0;  
            delay_counter <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    ack <= 0;  
                    if (req) begin  
                        data_out <= addr;  
                        state <= DELAY;  
                        delay_counter <= 0;  
                    end  
                end  
                DELAY: begin  
                    if (delay_counter < DELAY_CYCLES - 1) begin  
                        delay_counter <= delay_counter + 1;  
                    end else begin  
                        state <= RESPOND;  
                    end  
                end  
                RESPOND: begin  
                    ack <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule