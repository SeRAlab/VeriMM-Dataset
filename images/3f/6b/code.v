module restoring_divider #(parameter N = 8, parameter D = 4) (
    input clk,
    input rst,
    input [N-1:0] dividend,
    output reg [N-1:0] quotient,
    output reg [N-1:0] remainder
);
    reg [N-1:0] temp_dividend;
    reg [D-1:0] divisor;
    reg [N:0] current_value;
    reg [N-1:0] count;
    reg [1:0] state;

    localparam IDLE = 2'b00, SUBTRACT = 2'b01, SHIFT = 2'b10, DONE = 2'b11;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 0;
            remainder <= 0;
            temp_dividend <= 0;
            divisor <= 0;
            current_value <= 0;
            count <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    temp_dividend <= dividend;
                    divisor <= {D{1'b1}}; // assuming divisor is all ones for simplicity
                    quotient <= 0;
                    count <= N-1;
                    state <= SUBTRACT;
                end
                SUBTRACT: begin
                    current_value <= {temp_dividend[N-1], temp_dividend}; // Shift for subtraction
                    if (current_value >= divisor) begin
                        current_value <= current_value - divisor;
                        quotient[count] <= 1;
                    end else begin
                        quotient[count] <= 0;
                    end
                    temp_dividend <= current_value[N-1:0]; // Update temp_dividend
                    count <= count - 1;
                    if (count == 0) state <= DONE;
                end
                DONE: begin
                    remainder <= temp_dividend;
                    state <= IDLE; // Go back to IDLE state for next operation
                end
            endcase
        end
    end
endmodule