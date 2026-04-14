`timescale 1ns/1ps

module subtractor_4bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire [3:0] diff;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    subtractor_4bit dut (
        .a(a),
        .b(b),
        .diff(diff)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 4'd5;
            b = 4'd2;
            $display("Test Case %0d: Basic Subtraction (5 - 2)", test_num);
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 4'd10;
            b = 4'd10;
            $display("Test Case %0d: Zero Result (10 - 10)", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 4'd0;
            b = 4'd0;
            $display("Test Case %0d: Zero Inputs (0 - 0)", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 4'd0;
            b = 4'd1;
            $display("Test Case %0d: Underflow/Borrow (0 - 1)", test_num);
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 4'd15;
            b = 4'd0;
            $display("Test Case %0d: Subtracting Zero (15 - 0)", test_num);
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 4'd15;
            b = 4'd15;
            $display("Test Case %0d: Max Values (15 - 15)", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 4'd7;
            b = 4'd8;
            $display("Test Case %0d: Underflow (7 - 8)", test_num);
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 4'd12;
            b = 4'd4;
            $display("Test Case %0d: Simple Subtraction (12 - 4)", test_num);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = 4'd1;
            b = 4'd15;
            $display("Test Case %0d: Large Underflow (1 - 15)", test_num);
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a = 4'b1010;
            b = 4'b0101;
            $display("Test Case %0d: Pattern Check (10 - 5)", test_num);
            #1;

            check_outputs(4'd5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("subtractor_4bit Testbench");
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
        input [3:0] expected_diff;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_diff === (expected_diff ^ diff ^ expected_diff)) begin
                $display("PASS");
                $display("  Outputs: diff=%h",
                         diff);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: diff=%h",
                         expected_diff);
                $display("  Got:      diff=%h",
                         diff);
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
