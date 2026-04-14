`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg in1;
    reg in2;
    reg in3;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Input 000", test_num);
            in1 = 0; in2 = 0; in3 = 0;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Input 001", test_num);
            in1 = 0; in2 = 0; in3 = 1;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Input 010", test_num);
            in1 = 0; in2 = 1; in3 = 0;
            #1;

            check_outputs(8'h04);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Input 011", test_num);
            in1 = 0; in2 = 1; in3 = 1;
            #1;

            check_outputs(8'h08);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Input 100", test_num);
            in1 = 1; in2 = 0; in3 = 0;
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Input 101", test_num);
            in1 = 1; in2 = 0; in3 = 1;
            #1;

            check_outputs(8'h20);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Input 110", test_num);
            in1 = 1; in2 = 1; in3 = 0;
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Input 111", test_num);
            in1 = 1; in2 = 1; in3 = 1;
            #1;

            check_outputs(8'h80);
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
        input [7:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
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
