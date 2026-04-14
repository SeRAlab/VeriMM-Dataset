module top_module(
    input [7:0] I,
    input clk,            // Added clock input
    output reg EN,
    output reg [2:0] Y   // Changed Y to reg type
);reg [2:0] Y_reg;

always @ (posedge clk) begin
    Y_reg <= Y; // Y is now a reg type, so we can update it
end

always @ (posedge clk) begin
    if (I[0]) begin
        EN <= 0;
        Y <= 3'b000; // Changed Y to use a reg assignment
    end else if (I[1]) begin
        EN <= 0;
        Y <= 3'b001; // Changed Y to use a reg assignment
    end else if (I[2]) begin
        EN <= 0;
        Y <= 3'b010; // Changed Y to use a reg assignment
    end else if (I[3]) begin
        EN <= 0;
        Y <= 3'b011; // Changed Y to use a reg assignment
    end else if (I[4]) begin
        EN <= 0;
        Y <= 3'b100; // Changed Y to use a reg assignment
    end else if (I[5]) begin
        EN <= 0;
        Y <= 3'b101; // Changed Y to use a reg assignment
    end else if (I[6]) begin
        EN <= 0;
        Y <= 3'b110; // Changed Y to use a reg assignment
    end else if (I[7]) begin
        EN <= 0;
        Y <= 3'b111; // Changed Y to use a reg assignment
    end else begin
        EN <= 1;
        Y <= Y_reg;  // Y can now be assigned because it is a reg type
    end
end

endmodule