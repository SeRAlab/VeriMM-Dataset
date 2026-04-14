module fft_8point (  
    input clk,  
    input rst,  
    input start,  
    input [127:0] data_in,  
    output reg [127:0] data_out,  
    output reg done  
);  
    reg [2:0] state;  
    reg [15:0] x[0:7];  
    reg [15:0] y[0:7];  
    integer i;  

    localparam IDLE = 3'b000, LOAD = 3'b001, COMPUTE = 3'b010, OUTPUT = 3'b011, DONE = 3'b100;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            done <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        state <= LOAD;  
                    end  
                end  
                LOAD: begin  
                    for (i = 0; i < 8; i = i + 1) begin  
                        x[i] <= data_in[i * 16 +: 16];  
                    end  
                    state <= COMPUTE;  
                end  
                COMPUTE: begin  
                    // Implement the FFT computation here (simplified)  
                    // This is a placeholder for actual FFT logic  
                    for (i = 0; i < 8; i = i + 1) begin  
                        y[i] <= x[i]; // Replace with FFT computation  
                    end  
                    state <= OUTPUT;  
                end  
                OUTPUT: begin  
                    for (i = 0; i < 8; i = i + 1) begin  
                        data_out[i * 16 +: 16] <= y[i];  
                    end  
                    done <= 1;  
                    state <= DONE;  
                end  
                DONE: begin  
                    if (!start) begin  
                        done <= 0;  
                        state <= IDLE;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule