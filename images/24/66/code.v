module fixed_priority_arbiter (
    input wire clk,
    input wire rst_n,
    input wire [3:0] req,     // Request inputs
    output reg [3:0] grant    // Grant outputs
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            grant <= 4'b0000;  // Reset grant outputs
        end else begin
            grant <= 4'b0000;  // Default grant to none
            if (req[0]) grant <= 4'b0001; // Grant to request 0
            else if (req[1]) grant <= 4'b0010; // Grant to request 1
            else if (req[2]) grant <= 4'b0100; // Grant to request 2
            else if (req[3]) grant <= 4'b1000; // Grant to request 3
        end
    end
endmodule