module dma_controller (  
    input clk,  
    input reset,  
    input [7:0] address1,  
    input [7:0] address2,  
    input [7:0] data_in1,  
    input [7:0] data_in2,  
    input read1,  
    input write1,  
    input read2,  
    input write2,  
    output reg [7:0] data_out1,  
    output reg [7:0] data_out2,  
    output reg transfer_complete1,  
    output reg transfer_complete2  
);  

    reg [1:0] current_state;  
    reg [1:0] next_state;  

    localparam IDLE = 2'b00,  
               TRANSFER1 = 2'b01,  
               TRANSFER2 = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            current_state <= IDLE;  
        else  
            current_state <= next_state;  
    end  

    always @(*) begin  
        case (current_state)  
            IDLE: begin  
                if (write1) begin  
                    data_out1 = data_in1;  
                    transfer_complete1 = 1;  
                    next_state = TRANSFER1;  
                end else if (write2) begin  
                    data_out2 = data_in2;  
                    transfer_complete2 = 1;  
                    next_state = TRANSFER2;  
                end else begin  
                    next_state = IDLE;  
                end  
            end  
            TRANSFER1: begin  
                if (read1) begin  
                    data_out1 = data_in1;  
                    transfer_complete1 = 1;  
                    next_state = IDLE;  
                end else begin  
                    next_state = TRANSFER1;  
                end  
            end  
            TRANSFER2: begin  
                if (read2) begin  
                    data_out2 = data_in2;  
                    transfer_complete2 = 1;  
                    next_state = IDLE;  
                end else begin  
                    next_state = TRANSFER2;  
                end  
            end  
            default: next_state = IDLE;  
        endcase  
    end  
endmodule