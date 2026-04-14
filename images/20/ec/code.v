module IFFT4 (
    input clk,
    input [63:0] in_data,  // 4 complex numbers (16 bits each)
    output reg [63:0] out_data // 4 complex numbers (16 bits each)
);
    // Internal variables
    reg [15:0] X0, X1, X2, X3;
    reg [15:0] Y0, Y1, Y2, Y3;

    always @(posedge clk) begin
        // Simple IFFT calculation, replace this with actual logic
        X0 <= in_data[63:48]; // Get first complex number
        X1 <= in_data[47:32]; // Get second complex number
        X2 <= in_data[31:16]; // Get third complex number
        X3 <= in_data[15:0];  // Get fourth complex number

        // The actual IFFT logic should be here, for now, we just pass through
        Y0 <= X0; // Placeholder for actual processing
        Y1 <= X1;
        Y2 <= X2;
        Y3 <= X3;

        // Combine outputs
        out_data <= {Y0, Y1, Y2, Y3};
    end
endmodule