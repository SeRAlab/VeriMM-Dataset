module hmac_sha256 (  
    input clk,  
    input reset,  
    input start,  
    input [127:0] key,  
    input [127:0] message,  
    output reg [255:0] hmac_out,  
    output reg valid  
);  
    // States for HMAC computation  
    reg [1:0] state;  
    localparam IDLE = 2'b00, COMPUTE = 2'b01, DONE = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            valid <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        // Start HMAC computation  
                        state <= COMPUTE;  
                        valid <= 0;  
                    end  
                end  
                COMPUTE: begin  
                    // Simulate HMAC computation (this would be where the SHA-256 logic goes)  
                    hmac_out <= {key[127:96] ^ message[127:96], key[95:64] ^ message[95:64], key[63:32] ^ message[63:32], key[31:0] ^ message[31:0]};  
                    state <= DONE;  
                end  
                DONE: begin  
                    valid <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule