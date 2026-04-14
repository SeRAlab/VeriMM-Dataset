`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg iCLK_27;
    reg iRST_N;
    reg iSkip;
    reg iSwap_CbCr;
    reg [7:0] iTD_DATA;
    wire oDVAL;
    wire [31:0] oTV_Cont;
    wire [9:0] oTV_X;
    wire [9:0] oTV_Y;
    wire [15:0] oYCbCr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iCLK_27(iCLK_27),
        .iRST_N(iRST_N),
        .iSkip(iSkip),
        .iSwap_CbCr(iSwap_CbCr),
        .iTD_DATA(iTD_DATA),
        .oDVAL(oDVAL),
        .oTV_Cont(oTV_Cont),
        .oTV_X(oTV_X),
        .oTV_Y(oTV_Y),
        .oYCbCr(oYCbCr)
    );

    // Clock generation (10ns period)
    initial begin
        iCLK_27 = 0;
        forever #5 iCLK_27 = ~iCLK_27;
    end

        task reset_dut;

    begin
        iRST_N = 0;
        iSkip = 0;
        iSwap_CbCr = 0;
        iTD_DATA = 8'h00;
        @(posedge iCLK_27);
        #1 iRST_N = 1;
        @(posedge iCLK_27);
        test_num = test_num + 1;
        $display("Test Case %03d: Resetting DUT...", test_num);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        repeat (2) @(posedge iCLK_27);

        #1;


        check_outputs(1'b0, 32'h0, 10'h0, 10'h0, 16'h0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();


        @(posedge iCLK_27) iTD_DATA = 8'hFF;
        @(posedge iCLK_27) iTD_DATA = 8'h00;
        @(posedge iCLK_27) iTD_DATA = 8'h00;
        @(posedge iCLK_27) iTD_DATA = 8'h80;


        @(posedge iCLK_27) iTD_DATA = 8'hAA;
        @(posedge iCLK_27) iTD_DATA = 8'h55;


        repeat (2) @(posedge iCLK_27);



        #1;




        check_outputs(1'b1, 32'h1, 10'h1, 10'h0, 16'h55AA);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        iSwap_CbCr = 1;


        @(posedge iCLK_27) iTD_DATA = 8'hFF;
        @(posedge iCLK_27) iTD_DATA = 8'h00;
        @(posedge iCLK_27) iTD_DATA = 8'h00;
        @(posedge iCLK_27) iTD_DATA = 8'h80;


        @(posedge iCLK_27) iTD_DATA = 8'h11;
        @(posedge iCLK_27) iTD_DATA = 8'h22;

        repeat (2) @(posedge iCLK_27);




        #1;





        check_outputs(1'b1, 32'h1, 10'h1, 10'h0, 16'h2211);
    end
        endtask

    task testcase004;

    begin
        reset_dut();


        @(posedge iCLK_27) iTD_DATA = 8'hFF;
        @(posedge iCLK_27) iTD_DATA = 8'h00;
        @(posedge iCLK_27) iTD_DATA = 8'h00;
        @(posedge iCLK_27) iTD_DATA = 8'h80;


        @(posedge iCLK_27) iTD_DATA = 8'h10;
        @(posedge iCLK_27) iTD_DATA = 8'h20;

        @(posedge iCLK_27) iTD_DATA = 8'h30;
        @(posedge iCLK_27) iTD_DATA = 8'h40;

        repeat (2) @(posedge iCLK_27);



        #1;




        check_outputs(1'b1, 32'h2, 10'h2, 10'h0, 16'h4030);
    end
        endtask

    task testcase005;

    begin
        reset_dut();



        @(posedge iCLK_27) iTD_DATA = 8'hFF;
        @(posedge iCLK_27) iTD_DATA = 8'h00;
        @(posedge iCLK_27) iTD_DATA = 8'h00;
        @(posedge iCLK_27) iTD_DATA = 8'hB6;

        repeat (5) @(posedge iCLK_27);


        #1;



        check_outputs(1'b0, 32'h0, 10'h0, 10'h0, 16'h0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();


        @(posedge iCLK_27) iTD_DATA = 8'hFF;
        @(posedge iCLK_27) iTD_DATA = 8'h00;
        @(posedge iCLK_27) iTD_DATA = 8'h00;
        @(posedge iCLK_27) iTD_DATA = 8'h80;


        repeat (3) begin
            @(posedge iCLK_27) iTD_DATA = 8'hAA;
            @(posedge iCLK_27) iTD_DATA = 8'h55;
        end

        repeat (2) @(posedge iCLK_27);


        #1;



        check_outputs(1'b1, 32'h3, 10'h3, 10'h0, 16'h55AA);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input expected_oDVAL;
        input [31:0] expected_oTV_Cont;
        input [9:0] expected_oTV_X;
        input [9:0] expected_oTV_Y;
        input [15:0] expected_oYCbCr;
        begin
            if (expected_oDVAL === (expected_oDVAL ^ oDVAL ^ expected_oDVAL) &&
                expected_oTV_Cont === (expected_oTV_Cont ^ oTV_Cont ^ expected_oTV_Cont) &&
                expected_oTV_X === (expected_oTV_X ^ oTV_X ^ expected_oTV_X) &&
                expected_oTV_Y === (expected_oTV_Y ^ oTV_Y ^ expected_oTV_Y) &&
                expected_oYCbCr === (expected_oYCbCr ^ oYCbCr ^ expected_oYCbCr)) begin
                $display("PASS");
                $display("  Outputs: oDVAL=%b, oTV_Cont=%h, oTV_X=%h, oTV_Y=%h, oYCbCr=%h",
                         oDVAL, oTV_Cont, oTV_X, oTV_Y, oYCbCr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oDVAL=%b, oTV_Cont=%h, oTV_X=%h, oTV_Y=%h, oYCbCr=%h",
                         expected_oDVAL, expected_oTV_Cont, expected_oTV_X, expected_oTV_Y, expected_oYCbCr);
                $display("  Got:      oDVAL=%b, oTV_Cont=%h, oTV_X=%h, oTV_Y=%h, oYCbCr=%h",
                         oDVAL, oTV_Cont, oTV_X, oTV_Y, oYCbCr);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,iCLK_27, iRST_N, iSkip, iSwap_CbCr, iTD_DATA, oDVAL, oTV_Cont, oTV_X, oTV_Y, oYCbCr);
    end

endmodule
