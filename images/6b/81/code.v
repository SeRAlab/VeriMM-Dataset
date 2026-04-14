module top_module(
    output reg out,  // Change to output reg to allow assignment in always block
    input in,
    input clk,
    input reset_n
);parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;
parameter S3 = 2'b11;
reg [1:0] state, nextState;  // Change to 2-bit register for state

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        state <= S0;
        out <= 0;
    end else begin
        state <= nextState;
        // out is updated in the nextState logic, so no need to hold the old value
    end
end

always @(*) begin
    case(state) 
        S0: begin
            if (in == 0) begin
                nextState <= S0;
                out <= 0;
            end else begin
                nextState <= S1;
                out <= 1;
            end
        end
        S1: begin
            if (in == 0) begin
                nextState <= S1;
                out <= 0;
            end else begin
                nextState <= S2;
                out <= 1;
            end
        end
        S2: begin
            if (in == 0) begin
                nextState <= S2;
                out <= 0;
            end else begin
                nextState <= S3;
                out <= 1;
            end
        end
        S3: begin
            if (in == 0) begin
                nextState <= S3;
                out <= 0;
            end else begin
                nextState <= S0;
                out <= 1;
            end
        end
        default: begin
            nextState <= S0;  // Default case to avoid latches
            out <= 0;         // Default output
        end
    endcase
end

endmodule