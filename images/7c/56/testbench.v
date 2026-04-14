`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg iCLK;
    reg [7:0] iDATA;
    reg iRS;
    reg iRST_N;
    reg iStart;
    wire [7:0] LCD_DATA;
    wire LCD_EN;
    wire LCD_RS;
    wire LCD_RW;
    wire oDone;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iCLK(iCLK),
        .iDATA(iDATA),
        .iRS(iRS),
        .iRST_N(iRST_N),
        .iStart(iStart),
        .LCD_DATA(LCD_DATA),
        .LCD_EN(LCD_EN),
        .LCD_RS(LCD_RS),
        .LCD_RW(LCD_RW),
        .oDone(oDone)
    );

    // Clock generation (10ns period)
    initial begin
        iCLK = 0;
        forever #5 iCLK = ~iCLK;
    end

        task reset_dut;

        begin
            iRST_N = 0;
            iDATA = 8'h00;
            iRS = 0;
            iStart = 0;
            repeat (2) @(posedge iCLK);
            iRST_N = 1;
            repeat (1) @(posedge iCLK);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data Write (0x41, RS=1)", test_num);
            reset_dut();
            iDATA = 8'h41;
            iRS = 1;
            iStart = 1;
            @(posedge iCLK);
            iStart = 0;


            wait(oDone == 1);
            @(posedge iCLK);


            #1;



            check_outputs(8'h41, 1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Instruction Write (0x01 - Clear Display, RS=0)", test_num);
            reset_dut();
            iDATA = 8'h01;
            iRS = 0;
            iStart = 1;
            @(posedge iCLK);
            iStart = 0;

            wait(oDone == 1);
            @(posedge iCLK);


            #1;



            check_outputs(8'h01, 1'b0, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data Write (0x5A, RS=1)", test_num);
            reset_dut();
            iDATA = 8'h5A;
            iRS = 1;
            iStart = 1;
            @(posedge iCLK);
            iStart = 0;

            wait(oDone == 1);
            @(posedge iCLK);

            #1;


            check_outputs(8'h5A, 1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Write (0x00, RS=0)", test_num);
            reset_dut();
            iDATA = 8'h00;
            iRS = 0;
            iStart = 1;
            @(posedge iCLK);
            iStart = 0;

            wait(oDone == 1);
            @(posedge iCLK);

            #1;


            check_outputs(8'h00, 1'b0, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Write (0xFF, RS=1)", test_num);
            reset_dut();
            iDATA = 8'hFF;
            iRS = 1;
            iStart = 1;
            @(posedge iCLK);
            iStart = 0;

            wait(oDone == 1);
            @(posedge iCLK);

            #1;


            check_outputs(8'hFF, 1'b0, 1'b1, 1'b0, 1'b1);
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
        input [7:0] expected_LCD_DATA;
        input expected_LCD_EN;
        input expected_LCD_RS;
        input expected_LCD_RW;
        input expected_oDone;
        begin
            if (expected_LCD_DATA === (expected_LCD_DATA ^ LCD_DATA ^ expected_LCD_DATA) &&
                expected_LCD_EN === (expected_LCD_EN ^ LCD_EN ^ expected_LCD_EN) &&
                expected_LCD_RS === (expected_LCD_RS ^ LCD_RS ^ expected_LCD_RS) &&
                expected_LCD_RW === (expected_LCD_RW ^ LCD_RW ^ expected_LCD_RW) &&
                expected_oDone === (expected_oDone ^ oDone ^ expected_oDone)) begin
                $display("PASS");
                $display("  Outputs: LCD_DATA=%h, LCD_EN=%b, LCD_RS=%b, LCD_RW=%b, oDone=%b",
                         LCD_DATA, LCD_EN, LCD_RS, LCD_RW, oDone);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LCD_DATA=%h, LCD_EN=%b, LCD_RS=%b, LCD_RW=%b, oDone=%b",
                         expected_LCD_DATA, expected_LCD_EN, expected_LCD_RS, expected_LCD_RW, expected_oDone);
                $display("  Got:      LCD_DATA=%h, LCD_EN=%b, LCD_RS=%b, LCD_RW=%b, oDone=%b",
                         LCD_DATA, LCD_EN, LCD_RS, LCD_RW, oDone);
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
        $dumpvars(0,iCLK, iDATA, iRS, iRST_N, iStart, LCD_DATA, LCD_EN, LCD_RS, LCD_RW, oDone);
    end

endmodule
