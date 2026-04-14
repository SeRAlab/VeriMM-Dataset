module sata_controller(  
    input clk,  
    input rst_n,  
    input start,  
    input error,  
    output reg [1:0] state  
);  
    // State encoding  
    localparam IDLE   = 2'b00;  
    localparam ACTIVE = 2'b01;  
    localparam ERROR  = 2'b10;  
  
    // State Transition Logic  
    always @(posedge clk or negedge rst_n) begin  
        if (!rst_n)  
            state <= IDLE;  
        else begin  
            case (state)  
                IDLE: begin  
                    if (start)  
                        state <= ACTIVE;  
                end  
                ACTIVE: begin  
                    if (error)  
                        state <= ERROR;  
                    else if (!start)  
                        state <= IDLE;  
                end  
                ERROR: begin  
                    if (!error)  
                        state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule