module pcie_tx_fsm (  
    input clk,  
    input reset,  
    input start,  
    input signal_error,  
    input transmission_complete,  
    output reg [1:0] state  
);  
    // State encoding  
    localparam IDLE = 2'b00;  
    localparam TRANSMITTING = 2'b01;  
    localparam ERROR = 2'b10;  
    
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start)  
                        state <= TRANSMITTING;  
                end  
                TRANSMITTING: begin  
                    if (signal_error)  
                        state <= ERROR;  
                    else if (transmission_complete)  
                        state <= IDLE;  
                end  
                ERROR: begin  
                    if (transmission_complete)  
                        state <= IDLE;  
                end  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule