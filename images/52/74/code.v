module top_module(
    input ain, clk, reset,
    output reg [3:0] count,
    output reg yout
);reg [1:0] state, nextstate;
parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

// Initialize nextstate to S2
initial begin
    nextstate = S2;
end

// State transition logic
always @(state or ain) begin
    case(state)
        S0: begin
            if (ain) nextstate = S2;
            else nextstate = S0;
        end
        S1: begin
            if (ain) nextstate = S2;
            else nextstate = S1;
        end
        S2: begin
            if (ain) nextstate = S3;
            else nextstate = S2;
        end
        S3: begin
            if (ain) nextstate = S1;
            else nextstate = S3;
        end
    endcase
end

// State and output logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 4'b0000;
        state <= S0;
        yout <= 1'b0;
    end else begin
        if (ain) begin
            if (count == 4'b1111) begin
                count <= 4'b0000;
                state <= S0;
            end else begin
                count <= count + 1;
                state <= nextstate;
            end
        end
        case(state)
            S0: begin
                if (~ain) yout <= 1'b1;
                else yout <= 1'b0;
            end
            S1: begin
                if (ain) yout <= 1'b1;
                else yout <= 1'b0;
            end
            default: yout <= 1'b0;
        endcase
    end
end

endmodule