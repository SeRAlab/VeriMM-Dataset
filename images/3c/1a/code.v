module mux_2to1 (
    input [4:0] a,        // Input a
    input [4:0] b,        // Input b
    input sel,            // Select signal
    output reg [4:0] y,   // Output
    output reg hazard     // Hazard detection signal
);
    always @(*) begin
        if (sel) begin
            y = b;
            hazard = (a !== b); // Hazard detected if a and b are not the same
        end else begin
            y = a;
            hazard = (a !== b); // Hazard detected if a and b are not the same
        end
    end
endmodule