`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] x_in;
    wire [11:0] x_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x_in(x_in),
        .x_out(x_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            x_in = 12'b000_000_000_000;
            #1;

            check_outputs(12'b111_111_111_111);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones", test_num);
            x_in = 12'b111_111_111_111;
            #1;

            check_outputs(12'b000_000_000_000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits (5s)", test_num);
            x_in = 12'b101_101_101_101;
            #1;

            check_outputs(12'b010_010_010_010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits (2s)", test_num);
            x_in = 12'b010_010_010_010;
            #1;

            check_outputs(12'b101_101_101_101);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed Digits 1", test_num);

            x_in = 12'b000_111_011_100;

            #1;


            check_outputs(12'b111_000_100_011);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed Digits 2", test_num);

            x_in = 12'b001_010_101_110;

            #1;


            check_outputs(12'b110_101_010_001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Walking Bit 1", test_num);
            x_in = 12'b001_000_000_000;
            #1;

            check_outputs(12'b110_111_111_111);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Walking Bit 2", test_num);
            x_in = 12'b000_010_000_000;
            #1;

            check_outputs(12'b111_101_111_111);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Walking Bit 3", test_num);
            x_in = 12'b000_000_100_000;
            #1;

            check_outputs(12'b111_111_011_111);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Walking Zero", test_num);
            x_in = 12'b111_111_111_110;
            #1;

            check_outputs(12'b000_000_000_001);
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
        input [11:0] expected_x_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_x_out === (expected_x_out ^ x_out ^ expected_x_out)) begin
                $display("PASS");
                $display("  Outputs: x_out=%h",
                         x_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x_out=%h",
                         expected_x_out);
                $display("  Got:      x_out=%h",
                         x_out);
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
