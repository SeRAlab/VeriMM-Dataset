module shift_register (
    input [7:0] D,
    input CLK,
    input LOAD,
    input DIR,
    output reg [7:0] Q
);
    
    always @(posedge CLK) begin
        if (LOAD) begin
            Q <= D; // Load data
        end else begin
            if (DIR) begin
                Q <= {Q[6:0], 1'b0}; // Shift left
            end else begin
                Q <= {1'b0, Q[7:1]}; // Shift right
            end
        end
    end
endmodule