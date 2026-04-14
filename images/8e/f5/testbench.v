`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg sel;
    wire [7:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .sel(sel),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Addition - Positive Numbers (10 + 20)", test_num);
            A = 8'sd10;
            B = 8'sd20;
            sel = 1'b0;
            #1;

            check_outputs(8'sd30);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Addition - Negative Numbers (-15 + -5)", test_num);
            A = -8'sd15;
            B = -8'sd5;
            sel = 1'b0;
            #1;

            check_outputs(-8'sd20);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Addition - Mixed Signs (50 + -10)", test_num);
            A = 8'sd50;
            B = -8'sd10;
            sel = 1'b0;
            #1;

            check_outputs(8'sd40);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Addition - Positive Overflow (120 + 10)", test_num);

            A = 8'sd120;
            B = 8'sd10;
            sel = 1'b0;
            #1;

            check_outputs(8'h82);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Subtraction - Positive Numbers (50 - 20)", test_num);
            A = 8'sd50;
            B = 8'sd20;
            sel = 1'b1;
            #1;

            check_outputs(8'sd30);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Subtraction - Result Negative (10 - 30)", test_num);
            A = 8'sd10;
            B = 8'sd30;
            sel = 1'b1;
            #1;

            check_outputs(-8'sd20);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Subtraction - Negative Numbers (-10 - -5)", test_num);
            A = -8'sd10;
            B = -8'sd5;
            sel = 1'b1;
            #1;

            check_outputs(-8'sd5);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Subtraction - Negative Overflow (-120 - 10)", test_num);

            A = -8'sd120;
            B = 8'sd10;
            sel = 1'b1;
            #1;

            check_outputs(8'h7E);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Zero Case (0 + 0)", test_num);
            A = 8'sd0;
            B = 8'sd0;
            sel = 1'b0;
            #1;

            check_outputs(8'sd0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Zero Case (0 - 0)", test_num);
            A = 8'sd0;
            B = 8'sd0;
            sel = 1'b1;
            #1;

            check_outputs(8'sd0);
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
        input [7:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
