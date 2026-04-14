module sr_flip_flop (
    input wire S,
    input wire R,
    input wire clk,
    input wire rst,
    output reg Q,
    output reg Q_not
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Q <= 0;
            Q_not <= 1;
        end else begin
            case ({S, R})
                2'b00: ; // No change
                2'b01: begin
                    Q <= 0; 
                    Q_not <= 1; 
                end
                2'b10: begin
                    Q <= 1; 
                    Q_not <= 0; 
                end
                2'b11: begin
                    // Indeterminate state, remain in previous state
                end
            endcase
        end
    end
endmodule