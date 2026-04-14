module top_module(
    input clk,
    input reset,
    input [19:0] b,
    input [19:0] c,
    input [19:0] d,
    output reg [19:0] q
);reg [19:0] r_b;
reg [19:0] r_e;
reg [19:0] r_c;
reg [19:0] rr_e;
reg [19:0] rr_b;
reg [19:0] r_qx;
reg [19:0] rb;
reg [19:0] e2;

// Create the register (flip-flop) for the initial/1st stage
always@(posedge clk or posedge reset)
begin
    if(reset)
    begin
        r_b <= 0;
        r_e <= 0;
    end
    else
    begin
        r_e <= e2; // Assign e2 in the next clock cycle
        r_b <= d;
    end
end

// Create the register (flip-flop) for the 2nd stage
always@(posedge clk or posedge reset)
begin
    if(reset)
    begin
        r_c <= 0;
        rr_e <= 0;
        rr_b <= 0;
    end
    else
    begin
        r_c <= c;
        rr_e <= r_e;
        rr_b <= r_b;
    end
end

// Create the register (flip-flop) for the 3rd stage
always@(posedge clk or posedge reset)
begin
    if(reset)
    begin
        rb <= 0;
        r_qx <= 0; // Ensure r_qx is reset
        e2 <= 0;   // Ensure e2 is reset
    end
    else
    begin
        r_qx <= rr_b; // Use rr_b for r_qx
        rb <= rr_b;
        e2 <= rr_e;   // Properly assign rr_e to e2
    end
end

// Calculate the output q as the bitwise AND of inputs b, c, and d
assign q = b & c & d;

endmodule