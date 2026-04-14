`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in;
    wire [2:0] pCount;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .pCount(pCount)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Input 4'b0000", test_num);
            in = 4'b0000;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Input 4'b0001", test_num);
            in = 4'b0001;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Input 4'b1000", test_num);
            in = 4'b1000;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Input 4'b0011", test_num);
            in = 4'b0011;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Input 4'b1010", test_num);
            in = 4'b1010;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Input 4'b0111", test_num);
            in = 4'b0111;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Input 4'b1101", test_num);
            in = 4'b1101;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Input 4'b1111", test_num);
            in = 4'b1111;
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Input 4'b0101", test_num);
            in = 4'b0101;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Input 4'b1100", test_num);
            in = 4'b1100;
            #1;

            check_outputs(3'd2);
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
        input [2:0] expected_pCount;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pCount === (expected_pCount ^ pCount ^ expected_pCount)) begin
                $display("PASS");
                $display("  Outputs: pCount=%h",
                         pCount);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pCount=%h",
                         expected_pCount);
                $display("  Got:      pCount=%h",
                         pCount);
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
