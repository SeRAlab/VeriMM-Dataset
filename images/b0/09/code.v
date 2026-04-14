module top_module(
    input [7:0] A,
    input [7:0] B,
    output reg [7:0] Y
);reg [7:0] reg_Y;
reg [7:0] reg_A;
reg [7:0] reg_B;
reg [2:0] state;

always @(*) begin
    case(state)
        0: begin // initialize
            reg_Y <= 8'b0;
            reg_A <= A;
            reg_B <= B;
            state <= 1;
        end
        1: begin // shift A left by 1 bit
            reg_A <= {reg_A[6:0], 1'b0};
            state <= 2;
        end
        2: begin // compare A and B
            if(reg_A >= reg_B) begin
                reg_A <= reg_A - reg_B;
                reg_Y[0] <= 1'b1;
            end
            reg_Y <= {reg_Y[6:0], 1'b0};
            state <= 3;
        end
        3: begin // shift register left by 1 bit
            reg_Y <= {reg_Y[6:0], 1'b0};
            state <= 4;
        end
        4: begin // repeat for all bits of A
            if(reg_A != 8'b0) begin
                state <= 1;
            end else begin
                state <= 5;
            end
        end
        5: begin // output quotient
            Y <= reg_Y;
            state <= 0;
        end
    endcase
end

endmodule