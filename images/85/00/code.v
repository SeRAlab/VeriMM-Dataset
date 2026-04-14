module top_module(
    input CLK,
    input RST,
    input [7:0] BUS_ADDR,
    input [7:0] SWITCH_VALUE,
    output [7:0] BUS_DATA,
    input       BUS_WE 
    );parameter    [7:0]    SwitchBaseAddr    =    8'h80;



    reg [7:0] data_bus;




    always @ (posedge CLK) begin
        if (RST)
            data_bus <= 0;
        else begin
            if (BUS_ADDR == SwitchBaseAddr)
                data_bus <= SWITCH_VALUE;
            end
        end



    reg switch_we;

    always @ (posedge CLK) begin
        if (RST)
            switch_we <= 0;
        else begin
            if (BUS_ADDR == SwitchBaseAddr)
                switch_we <= 1;
            else
                switch_we <= 0;
            end
        end



    assign BUS_DATA = (switch_we) ? data_bus:8'hZZ;

endmodule