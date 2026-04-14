module pcie_endpoint_controller(input clk, input reset, input start, input ack, input done, output reg [1:0] state);  
    parameter IDLE = 2'b00, REQUEST = 2'b01, RESPONSE = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= IDLE;  
        else begin  
            case (state)  
                IDLE: if (start) state <= REQUEST;  
                REQUEST: if (ack) state <= RESPONSE;  
                RESPONSE: if (done) state <= IDLE;  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule