`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg in0;
    reg in1;
    reg in2;
    reg in3;
    reg s0;
    reg s1;
    reg vgnd;
    reg vpwr;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .s0(s0),
        .s1(s1),
        .vgnd(vgnd),
        .vpwr(vpwr),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Select in0 (s1=0, s0=0) - Value 1", test_num);
            vpwr = 1; vgnd = 0;
            in0 = 1; in1 = 0; in2 = 0; in3 = 0;
            s1 = 0; s0 = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Select in0 (s1=0, s0=0) - Value 0", test_num);
            vpwr = 1; vgnd = 0;
            in0 = 0; in1 = 1; in2 = 1; in3 = 1;
            s1 = 0; s0 = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Select in1 (s1=0, s0=1) - Value 1", test_num);
            vpwr = 1; vgnd = 0;
            in0 = 0; in1 = 1; in2 = 0; in3 = 0;
            s1 = 0; s0 = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Select in1 (s1=0, s0=1) - Value 0", test_num);
            vpwr = 1; vgnd = 0;
            in0 = 1; in1 = 0; in2 = 1; in3 = 1;
            s1 = 0; s0 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Select in2 (s1=1, s0=0) - Value 1", test_num);
            vpwr = 1; vgnd = 0;
            in0 = 0; in1 = 0; in2 = 1; in3 = 0;
            s1 = 1; s0 = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Select in2 (s1=1, s0=0) - Value 0", test_num);
            vpwr = 1; vgnd = 0;
            in0 = 1; in1 = 1; in2 = 0; in3 = 1;
            s1 = 1; s0 = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Select in3 (s1=1, s0=1) - Value 1", test_num);
            vpwr = 1; vgnd = 0;
            in0 = 0; in1 = 0; in2 = 0; in3 = 1;
            s1 = 1; s0 = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Select in3 (s1=1, s0=1) - Value 0", test_num);
            vpwr = 1; vgnd = 0;
            in0 = 1; in1 = 1; in2 = 1; in3 = 0;
            s1 = 1; s0 = 1;
            #1;

            check_outputs(1'b0);
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
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
