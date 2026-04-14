module top_module(
    input a, b, c, d, e, f,
    output reg x, y, z, // Changed to reg for process assignment
    output reg [1:0] pos 
);// 2:1 MUX for inputs a and b
    wire mux1_out;
    assign mux1_out = c ? b : a;

    // 2:1 MUX for inputs d and e
    wire mux2_out;
    assign mux2_out = f ? e : d;

    // Priority encoder for selecting highest priority input
    always @(*) begin
        if (mux1_out > mux2_out) begin
            x = mux1_out;
            y = a;
            z = b;
            pos = 2'b00;
        end else begin
            x = mux2_out;
            y = d;
            z = e;
            pos = 2'b01;
        end
    end

endmodule