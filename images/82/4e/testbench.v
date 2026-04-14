`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] div;
    reg [7:0] dvsr;
    wire [7:0] quot;
    wire [7:0] rem;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .div(div),
        .dvsr(dvsr),
        .quot(quot),
        .rem(rem)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 10 / 3", test_num);
        div = 8'sd10; dvsr = 8'sd3;
        #1;

        check_outputs(8'sd3, 8'sd1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 10 / -3", test_num);
        div = 8'sd10; dvsr = -8'sd3;
        #1;

        check_outputs(-8'sd3, 8'sd1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: -10 / 3", test_num);
        div = -8'sd10; dvsr = 8'sd3;
        #1;

        check_outputs(-8'sd3, -8'sd1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: -10 / -3", test_num);
        div = -8'sd10; dvsr = -8'sd3;
        #1;

        check_outputs(8'sd3, -8'sd1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 0 / 5", test_num);
        div = 8'sd0; dvsr = 8'sd5;
        #1;

        check_outputs(8'sd0, 8'sd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 5 / 0 (Divisor Zero)", test_num);
        div = 8'sd5; dvsr = 8'sd0;
        #1;

        check_outputs(8'shX, 8'shX);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 2 / 5", test_num);
        div = 8'sd2; dvsr = 8'sd5;
        #1;

        check_outputs(8'sd0, 8'sd2);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 20 / 5", test_num);
        div = 8'sd20; dvsr = 8'sd5;
        #1;

        check_outputs(8'sd4, 8'sd0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 127 / 1", test_num);
        div = 8'sd127; dvsr = 8'sd1;
        #1;

        check_outputs(8'sd127, 8'sd0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: -128 / 1", test_num);
        div = -8'sd128; dvsr = 8'sd1;
        #1;

        check_outputs(-8'sd128, 8'sd0);
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
        input [7:0] expected_quot;
        input [7:0] expected_rem;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_quot === (expected_quot ^ quot ^ expected_quot) &&
                expected_rem === (expected_rem ^ rem ^ expected_rem)) begin
                $display("PASS");
                $display("  Outputs: quot=%h, rem=%h",
                         quot, rem);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quot=%h, rem=%h",
                         expected_quot, expected_rem);
                $display("  Got:      quot=%h, rem=%h",
                         quot, rem);
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
