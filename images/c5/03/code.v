module shift_register (
    input CLK,
    input LOAD,
    input [7:0] DATA_IN,
    input SER_IN,
    output reg SER_OUT,
    output reg [7:0] Q
);

    reg [7:0] register;

    always @(posedge CLK) begin
        if (LOAD) begin
            register <= DATA_IN;
            Q <= DATA_IN;
        end
        else begin
            register <= {register[6:0], SER_IN};
            Q <= register;
        end
        SER_OUT <= register[0];
    end

endmodule