module top_module(
    address_a,
    address_b,
    clock,
    q_a,
    q_b
);input   [8:0]   address_a;
    input   [8:0]   address_b;
    input   clock;
    output reg [3:0]   q_a;  // Changed to 'reg' type
    output reg [3:0]   q_b;  // Changed to 'reg' type

    always @(posedge clock) begin
        if (address_a[8] == 1) begin
            q_a <= address_a[3:0] + 1;  // Changed to non-blocking assignment
        end else begin
            q_a <= address_a[3:0] + 2;  // Changed to non-blocking assignment
        end

        if (address_b[8] == 1) begin
            q_b <= address_b[3:0] + 1;  // Changed to non-blocking assignment
        end else begin
            q_b <= address_b[3:0] + 2;  // Changed to non-blocking assignment
        end
    end

endmodule