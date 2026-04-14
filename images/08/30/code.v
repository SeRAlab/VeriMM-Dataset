module booth_multiplier (
    input signed [n-1:0] A,
    input signed [n-1:0] B,
    output signed [2*n-1:0] P
);
    parameter n = 4; // You can change this value for different sizes
    reg signed [n-1:0] a;
    reg signed [n-1:0] b;
    reg [n:0] q;
    reg [n:0] m;
    reg [2*n-1:0] p;
    integer i;

    initial begin
        a = A;
        b = B;
        q = 0;
        m = a;
        p = 0;
        
        for (i = 0; i < n; i = i + 1) begin
            case ({q[n], b[n-1]})
                2'b01: p = p + m; // Add
                2'b10: p = p - m; // Subtract
                2'b00, 2'b11: p = p; // Do nothing
            endcase
            
            // Arithmetic right shift
            {p, q} = {p[n-1], p, q} >> 1;
        end
    end
    
    assign P = p;
endmodule