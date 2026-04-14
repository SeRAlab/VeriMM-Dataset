module top_module(
        input Reset,
        input [2:0] Address,
        input Cs,
        input Clk,
        input Iow,
        input [15:0] Wdata,
        output reg [15:0] leds,
        output reg[7:0] led_high
        );always @(posedge Clk or posedge Reset)
        begin
            if(Reset==1)
                begin
                    leds = 0;
                end
            else if(Cs==1'b1)
                begin
                    if(Iow==1'b1)
                        begin
                            case(Address[2:0])
                                3'b000: leds = Wdata;
                                3'b010: led_high=Wdata[7:0];
                                default:leds = leds;
                            endcase
                        end
                end
        end
    endmodule