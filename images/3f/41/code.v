module pcie_sm (  
    input clk,  
    input reset,  
    input valid_txn,  
    input ack_txn,  
    output reg [1:0] state  
);  

    localparam IDLE = 2'b00;  
    localparam REQUEST = 2'b01;  
    localparam ACKNOWLEDGE = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (valid_txn)  
                        state <= REQUEST;  
                end  
                REQUEST: begin  
                    if (ack_txn)  
                        state <= ACKNOWLEDGE;  
                end  
                ACKNOWLEDGE: begin  
                    state <= IDLE;  
                end  
                default: begin  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule