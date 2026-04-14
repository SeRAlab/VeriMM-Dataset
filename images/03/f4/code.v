module sata_controller (  
    input wire clk,  
    input wire reset,  
    input wire start,  
    input wire link_qualified,  
    output reg [1:0] state   
);  
    // State encoding  
    localparam IDLE = 2'b00,  
               LINK_QUAL = 2'b01,  
               LINK_ESTAB = 2'b10;  
    
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) state <= LINK_QUAL;  
                end  
                LINK_QUAL: begin  
                    if (link_qualified) state <= LINK_ESTAB;  
                end  
                LINK_ESTAB: begin  
                    if (reset) state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule