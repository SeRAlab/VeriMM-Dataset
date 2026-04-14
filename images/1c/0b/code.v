module crc_generator (  
    input clk,  
    input reset,  
    input [7:0] data_in,  
    input data_valid,  
    output reg [7:0] crc_out,  
    output reg crc_ready  
);  

    reg [7:0] crc;  
    reg [2:0] state;  
    reg [2:0] next_state;  

    localparam IDLE = 3'b000,  
               PROCESS = 3'b001,  
               OUTPUT = 3'b010;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            crc <= 8'b0;  
            crc_ready <= 0;  
        end else begin  
            state <= next_state;  
            if (state == PROCESS) begin  
                crc <= (crc << 1) ^ (data_in[7] ^ crc[7] ? 8'h1D : 8'h00);  
            end  
        end  
    end  

    always @* begin  
        next_state = state;  
        crc_ready = 0;  
        case (state)  
            IDLE: begin  
                if (data_valid) begin  
                    next_state = PROCESS;  
                end  
            end  
            PROCESS: begin  
                if (data_valid) begin  
                    next_state = PROCESS;  
                end else begin  
                    next_state = OUTPUT;  
                end  
            end  
            OUTPUT: begin  
                crc_out = crc;  
                crc_ready = 1;  
                next_state = IDLE;  
            end  
        endcase  
    end  
endmodule