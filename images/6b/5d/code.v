module top_module(
    input clk,
    input [15:0] disp_num,
    output reg [6:0] seg,
    output reg [3:0] anode
);reg [26:0] tick;
    reg [1:0] an;
    reg [3:0] num;

    // initialize anode and tick
    initial begin
        an <= 2'b00;
        tick <= 0;
    end

    // increment tick on each clock cycle
    always @(posedge clk) begin
        tick <= tick + 1;
    end

    // increment anode every 1ms
    always @(posedge tick[20]) begin
        an <= an + 1;
    end

    // update anode and segment values based on current anode and input number
    always @* begin
        case(an)
            2'b00: num = disp_num[3:0];
            2'b01: num = disp_num[7:4];
            2'b10: num = disp_num[11:8];
            2'b11: num = disp_num[15:12];
            default:;
        endcase

        case(num)
            4'h0 : seg = 7'b1000000;
            4'h1 : seg = 7'b1111001;
            4'h2 : seg = 7'b0100100;
            4'h3 : seg = 7'b0110000;
            4'h4 : seg = 7'b0011001;
            4'h5 : seg = 7'b0010010;
            4'h6 : seg = 7'b0000010;
            4'h7 : seg = 7'b1111000;
            4'h8 : seg = 7'b0000000;
            4'h9 : seg = 7'b0010000;
            4'hA : seg = 7'b0001000;
            4'hB : seg = 7'b0000011;
            4'hC : seg = 7'b1000110;
            4'hD : seg = 7'b0100001;
            4'hE : seg = 7'b0000110;
            4'hF : seg = 7'b0001110;
            default : seg = 7'bxxxxxxx; // invalid input, display "blank"
        endcase

        anode = ~(4'b1 << an);
    end

endmodule