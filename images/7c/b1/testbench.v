`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg i_0r;
    reg o_0a;
    reg o_1a;
    reg o_2a;
    reg o_3a;
    reg o_4a;
    reg reset;
    wire i_0a;
    wire o_0r;
    wire o_1r;
    wire o_2r;
    wire o_3r;
    wire o_4r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_0r(i_0r),
        .o_0a(o_0a),
        .o_1a(o_1a),
        .o_2a(o_2a),
        .o_3a(o_3a),
        .o_4a(o_4a),
        .reset(reset),
        .i_0a(i_0a),
        .o_0r(o_0r),
        .o_1r(o_1r),
        .o_2r(o_2r),
        .o_3r(o_3r),
        .o_4r(o_4r)
    );
    task testcase001;

        begin
            $display("Testcase 001: All inputs high, normal operation");
            test_num = 1;
            reset = 1;
            i_0r = 0; o_0a = 0; o_1a = 0; o_2a = 0; o_3a = 0; o_4a = 0;
            #10;
            reset = 0;
            #10;
            i_0r = 1;
            o_0a = 1; o_1a = 1; o_2a = 1; o_3a = 1; o_4a = 1;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Request high, but one acknowledge (o_0a) missing");
            test_num = 2;
            reset = 1;
            i_0r = 0; o_0a = 0; o_1a = 0; o_2a = 0; o_3a = 0; o_4a = 0;
            #10;
            reset = 0;
            #10;
            i_0r = 1;
            o_0a = 0; o_1a = 1; o_2a = 1; o_3a = 1; o_4a = 1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Request high, but one acknowledge (o_4a) missing");
            test_num = 3;
            reset = 1;
            i_0r = 0; o_0a = 0; o_1a = 0; o_2a = 0; o_3a = 0; o_4a = 0;
            #10;
            reset = 0;
            #10;
            i_0r = 1;
            o_0a = 1; o_1a = 1; o_2a = 1; o_3a = 1; o_4a = 0;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Distribution check - Request low, ignores acknowledges");
            test_num = 4;
            reset = 1;
            #10;
            reset = 0;
            #10;
            i_0r = 0;
            o_0a = 1; o_1a = 1; o_2a = 1; o_3a = 1; o_4a = 1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Reset suppression check");
            test_num = 5;
            reset = 1;
            i_0r = 1;
            o_0a = 1; o_1a = 1; o_2a = 1; o_3a = 1; o_4a = 1;
            #10;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Partial acknowledge combination");
            test_num = 6;
            reset = 1;
            #10;
            reset = 0;
            #10;
            i_0r = 1;
            o_0a = 1; o_1a = 1; o_2a = 0; o_3a = 0; o_4a = 0;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
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
        input expected_i_0a;
        input expected_o_0r;
        input expected_o_1r;
        input expected_o_2r;
        input expected_o_3r;
        input expected_o_4r;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_i_0a === (expected_i_0a ^ i_0a ^ expected_i_0a) &&
                expected_o_0r === (expected_o_0r ^ o_0r ^ expected_o_0r) &&
                expected_o_1r === (expected_o_1r ^ o_1r ^ expected_o_1r) &&
                expected_o_2r === (expected_o_2r ^ o_2r ^ expected_o_2r) &&
                expected_o_3r === (expected_o_3r ^ o_3r ^ expected_o_3r) &&
                expected_o_4r === (expected_o_4r ^ o_4r ^ expected_o_4r)) begin
                $display("PASS");
                $display("  Outputs: i_0a=%b, o_0r=%b, o_1r=%b, o_2r=%b, o_3r=%b, o_4r=%b",
                         i_0a, o_0r, o_1r, o_2r, o_3r, o_4r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: i_0a=%b, o_0r=%b, o_1r=%b, o_2r=%b, o_3r=%b, o_4r=%b",
                         expected_i_0a, expected_o_0r, expected_o_1r, expected_o_2r, expected_o_3r, expected_o_4r);
                $display("  Got:      i_0a=%b, o_0r=%b, o_1r=%b, o_2r=%b, o_3r=%b, o_4r=%b",
                         i_0a, o_0r, o_1r, o_2r, o_3r, o_4r);
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
