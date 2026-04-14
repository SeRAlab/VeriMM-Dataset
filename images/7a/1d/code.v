module top_module(
    input [3:0] A,
    input [3:0] B,
    input S_select, // Renamed S to avoid conflict
    output [3:0] S_out, // Renamed output S to S_out
    output Cout
);reg [3:0] temp;
    reg Cout_temp;

    always @(*) begin
        if(S_select == 1'b0) begin // Addition
            temp = A + B;
            Cout_temp = (temp[4] == 1) ? 1 : 0;
        end
        else begin // Subtraction
            temp = A - B;
            Cout_temp = (temp[4] == 1) ? 0 : 1;
        end
    end

    assign S_out = temp;
    assign Cout = Cout_temp;

endmodule