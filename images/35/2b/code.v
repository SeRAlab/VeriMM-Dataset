module bluetooth_status (
    input [4:0] signal_status,
    output reg active
);

always @* begin
    if (signal_status != 5'b00000) 
        active = 1;
    else 
        active = 0;
end

endmodule