`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] binary;
    wire [6:0] segment;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary(binary),
        .segment(segment)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Input binary = 4'b0000 (0)", test_num);
            binary = 4'b0000;
            #1;

            check_outputs(7'b0111111);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Input binary = 4'b0001 (1)", test_num);
            binary = 4'b0001;
            #1;

            check_outputs(7'b0000110);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Input binary = 4'b0010 (2)", test_num);
            binary = 4'b0010;
            #1;

            check_outputs(7'b1011011);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Input binary = 4'b0011 (3)", test_num);
            binary = 4'b0011;
            #1;

            check_outputs(7'b1001111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Input binary = 4'b0100 (4)", test_num);
            binary = 4'b0100;
            #1;

            check_outputs(7'b1100110);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Input binary = 4'b0101 (5)", test_num);
            binary = 4'b0101;
            #1;

            check_outputs(7'b1101101);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Input binary = 4'b0110 (6)", test_num);
            binary = 4'b0110;
            #1;

            check_outputs(7'b1111101);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Input binary = 4'b0111 (7)", test_num);
            binary = 4'b0111;
            #1;

            check_outputs(7'b0000111);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Input binary = 4'b1000 (8)", test_num);
            binary = 4'b1000;
            #1;

            check_outputs(7'b1111111);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Input binary = 4'b1001 (9)", test_num);
            binary = 4'b1001;
            #1;

            check_outputs(7'b1101111);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Test %0d: Input binary = 4'b1010 (10 - Default)", test_num);
            binary = 4'b1010;
            #1;

            check_outputs(7'b0000000);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Test %0d: Input binary = 4'b1111 (15 - Default)", test_num);
            binary = 4'b1111;
            #1;

            check_outputs(7'b0000000);
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
        testcase012();
        
        
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
        input [6:0] expected_segment;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_segment === (expected_segment ^ segment ^ expected_segment)) begin
                $display("PASS");
                $display("  Outputs: segment=%h",
                         segment);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: segment=%h",
                         expected_segment);
                $display("  Got:      segment=%h",
                         segment);
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
