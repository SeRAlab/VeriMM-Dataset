module top_module(
    input rstn, clk,
    input MSB_in, LSB_in,
    input [3:0] I_par,
    input [1:0] sel,
    output reg [3:0] A_par
);always @ (posedge clk, negedge rstn)
    begin
        if (!rstn)
        begin
            A_par <= 4'b0000;
        end
        else
        begin
            case (sel)
                2'b00 : A_par <= A_par;
                2'b01 : A_par <= {MSB_in, A_par[3:1]};
                2'b10 : A_par <= {A_par[2:0], LSB_in};
                2'b11 : A_par <= I_par;
            endcase
        end
    end
endmodule