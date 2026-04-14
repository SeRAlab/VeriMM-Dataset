module top_module(
    input [2:0] SEL,
    input EN, Y,
    output [7:0] I
    );wire [2:0] sel;
    wire en, y;
    reg [7:0] i;
    
    assign y = Y;
    assign sel = SEL;
    assign en = EN;
    
    always@(*)
        if(en)begin
            case(sel)
            3'd0: i[0] = y;
            3'd1: i[1] = y;
            3'd2: i[2] = y;
            3'd3: i[3] = y;
            3'd4: i[4] = y;
            3'd5: i[5] = y;
            3'd6: i[6] = y;
            3'd7: i[7] = y;
            endcase
        end
            
    assign I = i;endmodule