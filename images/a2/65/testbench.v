`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [3:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Sum(Sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 4'd0;
            B = 4'd0;
            $display("Testcase %0d: Addition of zeros (0 + 0)", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 4'd5;
            B = 4'd3;
            $display("Testcase %0d: Simple addition without carry (5 + 3)", test_num);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 4'd1;
            B = 4'd1;
            $display("Testcase %0d: Bit 0 carry propagation (1 + 1)", test_num);
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 4'd7;
            B = 4'd1;
            $display("Testcase %0d: Multiple carry propagation (7 + 1)", test_num);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 4'd15;
            B = 4'd0;
            $display("Testcase %0d: Boundary value A (15 + 0)", test_num);
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 4'd0;
            B = 4'd15;
            $display("Testcase %0d: Boundary value B (0 + 15)", test_num);
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 4'd8;
            B = 4'd8;
            $display("Testcase %0d: Overflow to zero (8 + 8)", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 4'd15;
            B = 4'd1;
            $display("Testcase %0d: Maximum overflow to zero (15 + 1)", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 4'd10;
            B = 4'd5;
            $display("Testcase %0d: Alternating bits sum (1010 + 0101)", test_num);
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 4'd15;
            B = 4'd15;
            $display("Testcase %0d: Maximum possible sum overflow (15 + 15)", test_num);
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            A = 4'd12;
            B = 4'd4;
            $display("Testcase %0d: Power of two carry (12 + 4)", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            A = 4'd9;
            B = 4'd6;
            $display("Testcase %0d: Random bit patterns (9 + 6)", test_num);
            #1;

            check_outputs(4'd15);
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
        input [3:0] expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: Sum=%h",
                         Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Sum=%h",
                         expected_Sum);
                $display("  Got:      Sum=%h",
                         Sum);
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
