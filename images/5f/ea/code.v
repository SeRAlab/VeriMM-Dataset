module top_module(
    input [7:0] Input,
    input Ein,
    output reg Eout,
    output reg GS,
    output reg [2:0] Number
    );always @ (Input, Ein)
    begin
        if (Ein == 0)		
            begin
            Eout = 0;
            GS = 0;
            Number = 3'b000;
            end
        else
            begin
            if (Input == 8'b00000000)	
                begin
                GS = 0;
                Eout = 1;
                Number = 3'b000;
                end
            else
                begin
                    GS = 1;
                    Eout = 0;			
                    if (Input[7] == 1)	
                        Number = 3'b111;
                    else if (Input[6] == 1)
                        Number = 3'b110;
                    else if (Input[5] == 1)
                        Number = 3'b101;
                    else if (Input[4] == 1)
                        Number = 3'b100;
                    else if (Input[3] == 1)
                        Number = 3'b011;
                    else if (Input[2] == 1)
                        Number = 3'b010;
                    else if (Input[1] == 1)
                        Number = 3'b001;
                    else
                        Number = 3'b000;
                end
            end
    end
endmodule