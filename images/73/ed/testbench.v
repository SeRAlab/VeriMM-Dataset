`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ADDSUB;
    reg [26:0] D_DATA;
    reg INMODE2;
    reg [26:0] PREADD_AB;
    wire [26:0] AD;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADDSUB(ADDSUB),
        .D_DATA(D_DATA),
        .INMODE2(INMODE2),
        .PREADD_AB(PREADD_AB),
        .AD(AD)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Addition (ADDSUB=0, INMODE2=1)", test_num);
        ADDSUB = 0;
        INMODE2 = 1;
        PREADD_AB = 27'h000000A;
        D_DATA = 27'h0000005;
        #1;

        check_outputs(27'h000000F);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Subtraction (ADDSUB=1, INMODE2=1)", test_num);
        ADDSUB = 1;
        INMODE2 = 1;
        PREADD_AB = 27'h0000014;
        D_DATA = 27'h0000006;
        #1;

        check_outputs(27'h000000E);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Addition with INMODE2 low (Result = PREADD_AB)", test_num);
        ADDSUB = 0;
        INMODE2 = 0;
        PREADD_AB = 27'h1234567;
        D_DATA = 27'h7654321;
        #1;

        check_outputs(27'h1234567);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Subtraction with INMODE2 low (Result = PREADD_AB)", test_num);
        ADDSUB = 1;
        INMODE2 = 0;
        PREADD_AB = 27'h7ABCDEF;
        D_DATA = 27'h0123456;
        #1;

        check_outputs(27'h7ABCDEF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Addition Overflow Check", test_num);
        ADDSUB = 0;
        INMODE2 = 1;
        PREADD_AB = 27'h7FFFFFF;
        D_DATA = 27'h0000001;
        #1;

        check_outputs(27'h0000000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Subtraction Underflow (Negative result)", test_num);
        ADDSUB = 1;
        INMODE2 = 1;
        PREADD_AB = 27'h0000000;
        D_DATA = 27'h0000001;
        #1;

        check_outputs(27'h7FFFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: All Zeros input", test_num);
        ADDSUB = 0;
        INMODE2 = 1;
        PREADD_AB = 27'h0000000;
        D_DATA = 27'h0000000;
        #1;

        check_outputs(27'h0000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Large Value Addition", test_num);
        ADDSUB = 0;
        INMODE2 = 1;
        PREADD_AB = 27'h3FFFFFF;
        D_DATA = 27'h3FFFFFF;
        #1;

        check_outputs(27'h7FFFFFE);
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
        testcase007();
        testcase008();
        
        
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
        input [26:0] expected_AD;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_AD === (expected_AD ^ AD ^ expected_AD)) begin
                $display("PASS");
                $display("  Outputs: AD=%h",
                         AD);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: AD=%h",
                         expected_AD);
                $display("  Got:      AD=%h",
                         AD);
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

endmodule
