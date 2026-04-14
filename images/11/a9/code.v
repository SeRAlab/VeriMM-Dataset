module JK_latch (
    input J,
    input K,
    input clk,
    input rst,
    output reg Q,
    output reg Qn
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Q <= 0;
            Qn <= 1;
        end else begin
            case ({J, K})
                2'b00: ; // No change
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