module restoring_divider(
    input clk,
    input rst,
    input [4:0] dividend,
    input [1:0] divisor,
    output reg [4:0] quotient,
    output reg [4:0] remainder,
    output reg valid
);
    reg [4:0] temp_dividend;
    reg [2:0] state;
    
    parameter IDLE = 3'b000,
              DIVIDE = 3'b001,
              RESTORE = 3'b010,
              DONE = 3'b011;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 5'b0;
            remainder <= 5'b0;
            valid <= 0;
            state <= IDLE;
        end else begin
            case(state)
                IDLE: begin
                    if (divisor != 2'b00) begin
                        temp_dividend <= dividend;
                        quotient <= 5'b0;
                        state <= DIVIDE;
                    end else begin
                        quotient <= 5'b11111; // Undefined behavior for divisor = 0
                        valid <= 1;
                    end
                end
                DIVIDE: begin
                    temp_dividend <= {temp_dividend[3:0], 1'b0}; // Shift left
                    if (temp_dividend >= {3'b0, divisor}) begin
                        temp_dividend <= temp_dividend - {3'b0, divisor}; // Subtract
                        quotient <= {quotient[3:0], 1'b1}; // Set bit in quotient
                    end else begin
                        quotient <= {quotient[3:0], 1'b0}; // Clear bit in quotient
                    end
                    if (quotient == 5'b11111) begin // Check for completion
                        state <= DONE;
                    end
                end
                DONE: begin
                    remainder <= temp_dividend;
                    valid <= 1;
                    state <= IDLE; // Go back to IDLE
                end
            endcase
        end
    end
endmodule