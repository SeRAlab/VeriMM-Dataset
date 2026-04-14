`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg in1;
    reg in2;
    wire out1;
    wire out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .out1(out1),
        .out2(out2)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Testing Initial/Reset State (in1=0, in2=0)", test_num);
        in1 = 0; in2 = 0;
        #10;

        #1;


        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Testing Transition to S1 (in1=0, in2=1)", test_num);
        in1 = 0; in2 = 1;
        #10;

        #1;


        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Testing Transition to S2 (in1=1, in2=0)", test_num);
        in1 = 1; in2 = 0;
        #10;

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Testing Transition to S3 (in1=1, in2=1)", test_num);
        in1 = 1; in2 = 1;
        #10;

        #1;


        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Testing Input Stability (Hold 1,1)", test_num);
        in1 = 1; in2 = 1;
        #20;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Returning to Base State (in1=0, in2=0)", test_num);
        in1 = 0; in2 = 0;
        #10;
        #1;

        check_outputs(1'b0, 1'b0);
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
        input expected_out1;
        input expected_out2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2)) begin
                $display("PASS");
                $display("  Outputs: out1=%b, out2=%b",
                         out1, out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%b, out2=%b",
                         expected_out1, expected_out2);
                $display("  Got:      out1=%b, out2=%b",
                         out1, out2);
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
