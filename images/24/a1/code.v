module JK_FF (
    input J,
    input K,
    input Clock,
    input Clear,
    output reg Q,
    output reg Qn
);
    always @(posedge Clock or posedge Clear) begin
        if (Clear) begin
            Q <= 0;
            Qn <= 1;
        end else begin
            case ({J, K})
                2'b00: begin // No change
                    Q <= Q;
                    Qn <= ~Q;
                end
                2'b01: begin // Reset
                    Q <= 0;
                    Qn <= 1;
                end
                2'b10: begin // Set
                    Q <= 1;
                    Qn <= 0;
                end
                2'b11: begin // Toggle
                    Q <= ~Q;
                    Qn <= ~Qn;
                end
            endcase
        end
    end
endmodule