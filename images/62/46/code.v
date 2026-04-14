module top_module(
    input A,
    input B,
    input CLK,
    input EN,
    input CLR,
    output reg X,
    output reg Y
);reg X_buf;
    reg Y_buf;
    reg [1:0] state;

    always @(posedge CLK) begin
        if (CLR) begin
            X_buf <= 0;
            Y_buf <= 0;
            state <= 0;
        end else if (EN) begin
            case (state)
                0: begin
                    X_buf <= A;
                    Y_buf <= B;
                    state <= 1;
                end
                1: begin
                    X_buf <= X_buf;
                    Y_buf <= Y_buf;
                    state <= 2;
                end
                2: begin
                    X_buf <= X_buf;
                    Y_buf <= Y_buf;
                    state <= 0;
                end
            endcase
        end
    end

    assign X = X_buf;
    assign Y = Y_buf;

endmodule