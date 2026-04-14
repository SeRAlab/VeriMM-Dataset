module JK_FF (
    input wire J,
    input wire K,
    input wire CLK,
    input wire RST,
    input wire SET,
    output reg Q,
    output reg Qn
);
    always @(posedge CLK or posedge RST or posedge SET) begin
        if (RST) begin
            Q <= 0;
            Qn <= 1;
        end else if (SET) begin
            Q <= 1;
            Qn <= 0;
        end else begin
            case ({J, K})
                2'b00: begin // No change
                    Q <= Q;
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