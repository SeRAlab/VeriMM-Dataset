module pcie_sm(  
    input wire clk,  
    input wire reset,  
    input wire request,  
    input wire acknowledge,  
    output reg [1:0] state  
);  
    // State encoding  
    localparam IDLE = 2'b00;  
    localparam REQUEST = 2'b01;  
    localparam DATA = 2'b10;  

    // Sequential logic for state transitions  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (request)  
                        state <= REQUEST;  
                end  
                REQUEST: begin  
                    if (acknowledge)  
                        state <= DATA;  
                end  
                DATA: begin  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule