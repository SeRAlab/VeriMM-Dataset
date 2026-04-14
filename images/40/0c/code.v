module pcie_endpoint (  
    input wire clk,  
    input wire reset,  
    input wire req,  
    output reg ack,  
    output reg [31:0] read_data  
);  
    reg [1:0] state;  
    localparam IDLE = 2'b00, WAIT = 2'b01, RESPOND = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            ack <= 0;  
            read_data <= 32'b0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    ack <= 0;  
                    if (req) begin  
                        state <= WAIT;  
                    end  
                end  
                WAIT: begin  
                    state <= RESPOND;  
                end  
                RESPOND: begin  
                    ack <= 1;  
                    read_data <= 32'hDEADBEEF;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule