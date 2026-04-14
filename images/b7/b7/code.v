module top_module(
    input CLK,
    input UP,
    input DOWN,
    input RST,
    input [3:0] A,
    output [2:0] Q,
    output [7:0] Y
);// Up/Down Counter with Synchronous Reset
    reg [2:0] count;
    always @(posedge CLK) begin
        if (RST) begin
            count <= 3'b0;
        end else if (UP) begin
            count <= count + 1;
        end else if (DOWN) begin
            count <= count - 1;
        end
    end
    assign Q = count;

    // Binary Multiplier using Booth's Algorithm
    reg [7:0] B;
    always @(A or B) begin
        B = {4'b0, A};
    end
    reg [7:0] P;
    always @(posedge CLK) begin
        if (RST) begin
            P <= 8'b0;
        end else begin
            case (P[1:0])
                2'b00: P <= {P[7], P[7:2] - B};
                2'b01: P <= {P[7], P[7:2] + B};
                2'b10: P <= {P[7], P[7:2] + B};
                2'b11: P <= {P[7], P[7:2] - B};
            endcase
        end
    end
    assign Y = P[7:0];

    // Additional Functional Module - Adder
    reg [7:0] sum;
    always @(Q or Y) begin
        sum = Q + Y;
    end

endmodule