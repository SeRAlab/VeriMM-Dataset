`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ain;
    reg [3:0] bin;
    wire [4:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ain(ain),
        .bin(bin),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Adding zeros (0 + 0)", test_num);
            ain = 4'd0;
            bin = 4'd0;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Small values (2 + 3)", test_num);
            ain = 4'd2;
            bin = 4'd3;
            #1;

            check_outputs(5'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Maximum ain with zero bin (15 + 0)", test_num);
            ain = 4'd15;
            bin = 4'd0;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Zero ain with maximum bin (0 + 15)", test_num);
            ain = 4'd0;
            bin = 4'd15;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Maximum values (15 + 15) - Overflow check", test_num);
            ain = 4'd15;
            bin = 4'd15;
            #1;

            check_outputs(5'd30);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Sum resulting in exactly 16 (8 + 8)", test_num);
            ain = 4'd8;
            bin = 4'd8;
            #1;

            check_outputs(5'd16);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Mixed values (10 + 5)", test_num);
            ain = 4'd10;
            bin = 4'd5;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Boundary check (7 + 9)", test_num);
            ain = 4'd7;
            bin = 4'd9;
            #1;

            check_outputs(5'd16);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Random addition (12 + 13)", test_num);
            ain = 4'd12;
            bin = 4'd13;
            #1;

            check_outputs(5'd25);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Odd sum (1 + 14)", test_num);
            ain = 4'd1;
            bin = 4'd14;
            #1;

            check_outputs(5'd15);
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
        input [4:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
