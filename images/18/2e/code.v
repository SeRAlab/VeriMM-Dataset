module jk_flip_flop (
    input J,
    input K,
    input clk,
    input reset,
    output reg Q,
    output reg Qn
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Q <= 1'b0;
            Qn <= 1'b1;
        end else begin
            case ({J, K})
                2'b00: ; // No Change
                2'b01: begin
                    Q <= 1'b0;  // Reset
                    Qn <= 1'b1;
                end
                2'b10: begin
                    Q <= 1'b1;  // Set
                    Qn <= 1'b0;
                end
                2'b11: begin
                    Q <= ~Q;    // Toggle
                    Qn <= ~Qn;
                end
            endcase
        end
    end
endmodule