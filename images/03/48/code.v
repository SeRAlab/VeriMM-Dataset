module JKFF (
    input wire J,
    input wire K,
    input wire clk,
    input wire rst,
    input wire preset,
    output reg Q
);
    always @(posedge clk or posedge rst or posedge preset) begin
        if (rst) 
            Q <= 0; // asynchronous reset
        else if (preset) 
            Q <= 1; // asynchronous preset
        else begin
            case ({J, K})
                2'b00: Q <= Q;      // No change
                2'b01: Q <= 0;      // Reset
                2'b10: Q <= 1;      // Set
                2'b11: Q <= ~Q;     // Toggle
            endcase
        end
    end
endmodule