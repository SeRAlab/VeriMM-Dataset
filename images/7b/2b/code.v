module top_module(
    input CLK,
    input [3:0] a,
    input [3:0] b,
    input sub,
    input UP_DOWN,
    input LOAD,
    input [2:0] LOAD_VAL,
    input CARRY_IN,
    output reg cout,
    output reg overflow,
    output reg [3:0] Q,
    output reg [2:0] counter_out
);reg [3:0] counter;
reg [3:0] sum;
reg [3:0] diff;

always @(posedge CLK) begin
    if (LOAD) begin
        counter <= LOAD_VAL;
    end else if (UP_DOWN) begin
        if (CARRY_IN) begin
            counter <= counter + 1;
        end else begin
            counter <= counter - 1;
        end
    end else begin
        if (CARRY_IN) begin
            counter <= counter - 1;
        end else begin
            counter <= counter + 1;
        end
    end
end

always @(*) begin
    if (sub) begin
        diff = counter - b;
        if (diff < a) begin
            overflow = 1;
        end else begin
            overflow = 0;
        end
        Q = diff;
    end else begin
        sum = counter + b;
        if (sum < a) begin
            overflow = 1;
        end else begin
            overflow = 0;
        end
        Q = sum;
    end
    
    if (UP_DOWN) begin
        if (CARRY_IN) begin
            if (counter == 4'b1111) begin
                cout = 1;
            end else begin
                cout = 0;
            end
        end else begin
            if (counter == 4'b0000) begin
                cout = 1;
            end else begin
                cout = 0;
            end
        end
    end else begin
        if (CARRY_IN) begin
            if (Q == 4'b1111) begin
                cout = 1;
            end else begin
                cout = 0;
            end
        end else begin
            if (Q == 4'b0000) begin
                cout = 1;
            end else begin
                cout = 0;
            end
        end
    end
    
    counter_out = counter;
end

endmodule