module top_module(oe, bidirin, io, iobar);input oe;
    inout bidirin;
    inout io;
    inout iobar;
        
    parameter io_standard = "NONE";
    parameter current_strength = "NONE";
    parameter current_strength_new = "NONE";
    parameter slew_rate = -1;
    parameter location = "NONE";
    parameter enable_bus_hold = "NONE";
    parameter weak_pull_up_resistor = "NONE"; 
    parameter termination = "NONE"; 
    parameter input_termination = "NONE"; 
    parameter output_termination = "NONE"; 
    parameter lpm_type = "alt_bidir_diff";
    
    reg out_tmp;

    always @(io or iobar)
    begin
    casex({io,iobar})
            2'b00: out_tmp = 1'bx;
            2'b01: out_tmp = 1'b0;
            2'b10: out_tmp = 1'b1;
            2'b11: out_tmp = 1'bx;
            default: out_tmp = 1'bx;
        endcase
    end

    assign bidirin = (oe === 1'b0) ? out_tmp : (oe === 1'b1) ? 1'bz : 1'bx;
    assign io = (oe === 1'b1) ? bidirin : (oe === 1'b0) ? 1'bz : 1'bx;
    assign iobar = (oe == 1'b1) ? !bidirin : (oe == 1'b0) ?  1'bz : 1'bx;

endmodule