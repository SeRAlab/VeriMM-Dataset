`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [12:0] in0;
    reg [12:0] in1;
    wire [12:0] out0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in0(in0),
        .in1(in1),
        .out0(out0)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Positive vs Positive (in0 > in1)", test_num);
            in0 = 13'sd500;
            in1 = 13'sd200;
            #1;
            #1;

            check_outputs(13'sd500);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Positive vs Positive (in1 > in0)", test_num);
            in0 = 13'sd100;
            in1 = 13'sd1200;
            #1;
            #1;

            check_outputs(13'sd1200);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Negative vs Negative (in0 > in1)", test_num);
            in0 = -13'sd50;
            in1 = -13'sd100;
            #1;
            #1;

            check_outputs(-13'sd50);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Negative vs Negative (in1 > in0)", test_num);
            in0 = -13'sd1000;
            in1 = -13'sd500;
            #1;
            #1;

            check_outputs(-13'sd500);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Mixed signs (in0 positive)", test_num);
            in0 = 13'sd1;
            in1 = -13'sd1;
            #1;
            #1;

            check_outputs(13'sd1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Mixed signs (in1 positive)", test_num);
            in0 = -13'sd4000;
            in1 = 13'sd5;
            #1;
            #1;

            check_outputs(13'sd5);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Boundary values (Max Positive vs Min Negative)", test_num);
            in0 = 13'sd4095;
            in1 = -13'sd4096;
            #1;
            #1;

            check_outputs(13'sd4095);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Boundary values (Min Negative vs second lowest)", test_num);
            in0 = -13'sd4096;
            in1 = -13'sd4095;
            #1;
            #1;

            check_outputs(-13'sd4095);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Zero vs Negative", test_num);
            in0 = 13'sd0;
            in1 = -13'sd1;
            #1;
            #1;

            check_outputs(13'sd0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Equality case (Positive)", test_num);
            in0 = 13'sd2048;
            in1 = 13'sd2048;
            #1;
            #1;

            check_outputs(13'sd2048);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Testcase %0d: Equality case (Negative)", test_num);
            in0 = -13'sd2048;
            in1 = -13'sd2048;
            #1;
            #1;

            check_outputs(-13'sd2048);
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
        testcase011();
        
        
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
        input [12:0] expected_out0;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out0 === (expected_out0 ^ out0 ^ expected_out0)) begin
                $display("PASS");
                $display("  Outputs: out0=%h",
                         out0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out0=%h",
                         expected_out0);
                $display("  Got:      out0=%h",
                         out0);
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
