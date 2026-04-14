module JK_flip_flop (
    input wire J,
    input wire K,
    input wire clk,
    input wire rst_n,
    input wire preset,
    output reg Q
);
    
    always @(posedge clk or negedge rst_n or posedge preset) begin
        if (!rst_n) begin
            Q <= 0; // Asynchronous reset
        end else if (preset) begin
            Q <= 1; // Asynchronous preset
        end else begin
            case ({J, K})
                2'b00: Q <= Q; // No change
                2'b01: Q <= 0; // Reset
                2'b10: Q <= 1; // Set
                2'b11: Q <= ~Q; // Toggle
            endcase
        end
    end
endmodule