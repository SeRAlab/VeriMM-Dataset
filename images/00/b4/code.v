module sha256_hash (
    input wire clk,
    input wire reset,
    input wire valid_in,
    input wire [511:0] message,
    output reg [255:0] hash,
    output reg ready_out
);
    reg [3:0] state;
    
    parameter IDLE = 4'b0000, PROCESS = 4'b0001, OUTPUT = 4'b0010;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            hash <= 256'b0;
            ready_out <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (valid_in) begin
                        // Simulate processing of the input message
                        state <= PROCESS;
                        // A simple transformation to mimic hash generation (not a real hash function)
                        hash <= message[255:0] ^ {message[511:256], 128'b0};
                    end
                end
                PROCESS: begin
                    state <= OUTPUT;
                end
                OUTPUT: begin
                    ready_out <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule