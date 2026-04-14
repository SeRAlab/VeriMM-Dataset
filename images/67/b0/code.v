module top_module(
    input clk,
    input reset,
    input b,
    input e,
    input c,
    output reg cx,  // Change `cx` to reg to assign a value
    output reg r_b,
    output reg r_e,
    output reg r_c,
    output reg rr_b,
    output reg rr_e,
    output reg rb,
    output reg e2
);// Create the register (flip-flop) for the initial/1st stage
always@(posedge clk)
begin
    if(reset)
    begin
        r_b <= 0;
        r_e <= 0;
    end
    else
    begin
        r_e <= e;
        r_b <= b;
    end
end

// Create the register (flip-flop) for the 2nd stage
always@(posedge clk)
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
always@(posedge clk)
begin
    if(reset)
    begin
        rb <= 0;
        cx <= 0; // Initialize cx in case of reset
    end
    else
    begin
        rb <= rr_b;
        e2 <= rr_e;
        if (reset == 0)
            cx <= c;
    end
end

endmodule