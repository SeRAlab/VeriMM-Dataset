`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire f3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .f3(f3)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: MSB both 0, other bits 0");
            a = 4'b0000;
            b = 4'b0000;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: MSB a=1, b=0");
            a = 4'b1000;
            b = 4'b0000;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: MSB a=0, b=1");
            a = 4'b0000;
            b = 4'b1000;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: MSB both 1");
            a = 4'b1000;
            b = 4'b1000;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: MSB 0, all lower bits 1");
            a = 4'b0111;
            b = 4'b0111;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: MSB XOR 1, all lower bits 1");
            a = 4'b1111;
            b = 4'b0111;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case 007: All bits 1");
            a = 4'b1111;
            b = 4'b1111;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case 008: Alternating bits, MSB XOR 1");
            a = 4'b1010;
            b = 4'b0101;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case 009: Random variation 1");
            a = 4'b1011;
            b = 4'b1101;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case 010: Random variation 2");
            a = 4'b0100;
            b = 4'b1011;

            #1;


            check_outputs(1'b1);
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
        input expected_f3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_f3 === (expected_f3 ^ f3 ^ expected_f3)) begin
                $display("PASS");
                $display("  Outputs: f3=%b",
                         f3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: f3=%b",
                         expected_f3);
                $display("  Got:      f3=%b",
                         f3);
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
