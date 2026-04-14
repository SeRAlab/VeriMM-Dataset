module md5_simulator(  
    input clk,  
    input reset,  
    input [511:0] data_in,  
    input data_valid,  
    output reg [127:0] hash_out,  
    output reg hash_ready  
);  
    reg [127:0] A, B, C, D;  
    reg [31:0] count;  
    reg [3:0] state;  
    reg [511:0] buffer;  

    // State definitions  
    localparam IDLE = 4'd0, PROCESS = 4'd1, OUTPUT = 4'd2;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            A <= 32'h67452301;  
            B <= 32'hefcdab89;  
            C <= 32'h98badcfe;  
            D <= 32'h10325476;  
            hash_out <= 0;  
            hash_ready <= 0;  
            state <= IDLE;  
            count <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (data_valid) begin  
                        buffer <= data_in;  
                        count <= count + 1;  
                        state <= PROCESS;  
                    end  
                end  
                PROCESS: begin  
                    // Simplified process step (not the real MD5 logic)  
                    // In a real implementation, this is where the rounds would occur  
                    A <= A + buffer[31:0];  
                    B <= B + buffer[63:32];  
                    C <= C + buffer[95:64];  
                    D <= D + buffer[127:96];  
                    state <= OUTPUT;  
                end  
                OUTPUT: begin  
                    hash_out <= {A, B, C, D};  
                    hash_ready <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule