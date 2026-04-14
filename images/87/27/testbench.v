`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] iSOURCE0;
    reg [3:0] iSOURCE1;
    wire [7:0] oOUTPUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iSOURCE0(iSOURCE0),
        .iSOURCE1(iSOURCE1),
        .oOUTPUT(oOUTPUT)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Zero Multiplication (0 x 0)", test_num);
        iSOURCE0 = 4'd0;
        iSOURCE1 = 4'd0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Zero Multiplication (15 x 0)", test_num);
        iSOURCE0 = 4'd15;
        iSOURCE1 = 4'd0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Multiplicative Identity (1 x 1)", test_num);
        iSOURCE0 = 4'd1;
        iSOURCE1 = 4'd1;
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Multiplicative Identity (15 x 1)", test_num);
        iSOURCE0 = 4'd15;
        iSOURCE1 = 4'd1;
        #1;

        check_outputs(8'd15);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Powers of Two (2 x 4)", test_num);
        iSOURCE0 = 4'd2;
        iSOURCE1 = 4'd4;
        #1;

        check_outputs(8'd8);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Simple Multiplication (3 x 5)", test_num);
        iSOURCE0 = 4'd3;
        iSOURCE1 = 4'd5;
        #1;

        check_outputs(8'd15);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Mid-range Multiplication (10 x 5)", test_num);
        iSOURCE0 = 4'd10;
        iSOURCE1 = 4'd5;
        #1;

        check_outputs(8'd50);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: High-range Multiplication (12 x 12)", test_num);
        iSOURCE0 = 4'd12;
        iSOURCE1 = 4'd12;
        #1;

        check_outputs(8'd144);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Prime Multiplication (7 x 13)", test_num);
        iSOURCE0 = 4'd7;
        iSOURCE1 = 4'd13;
        #1;

        check_outputs(8'd91);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Maximum Multiplication (15 x 15)", test_num);
        iSOURCE0 = 4'd15;
        iSOURCE1 = 4'd15;
        #1;

        check_outputs(8'd225);
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
        testcase009();
        testcase010();
        
        
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
        input [7:0] expected_oOUTPUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_oOUTPUT === (expected_oOUTPUT ^ oOUTPUT ^ expected_oOUTPUT)) begin
                $display("PASS");
                $display("  Outputs: oOUTPUT=%h",
                         oOUTPUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oOUTPUT=%h",
                         expected_oOUTPUT);
                $display("  Got:      oOUTPUT=%h",
                         oOUTPUT);
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
