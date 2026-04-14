`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg sel;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .sel(sel),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 8'h05;
            B = 8'h03;
            sel = 0;
            $display("Test %0d: Addition (5 + 3)", test_num);
            #1;

            check_outputs(8'h08);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 8'h0A;
            B = 8'h04;
            sel = 1;
            $display("Test %0d: Subtraction (10 - 4)", test_num);
            #1;

            check_outputs(8'h06);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 8'hFF;
            B = 8'h01;
            sel = 0;
            $display("Test %0d: Addition overflow (255 + 1)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 8'h00;
            B = 8'h01;
            sel = 1;
            $display("Test %0d: Subtraction underflow (0 - 1)", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 8'hFF;
            B = 8'hFF;
            sel = 0;
            $display("Test %0d: Max values addition (255 + 255)", test_num);
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 8'h10;
            B = 8'h20;
            sel = 1;
            $display("Test %0d: Subtraction negative result (16 - 32)", test_num);
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 8'h00;
            B = 8'h00;
            sel = 0;
            $display("Test %0d: Zero addition (0 + 0)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 8'hAA;
            B = 8'hAA;
            sel = 1;
            $display("Test %0d: Subtraction zero result (0xAA - 0xAA)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 8'h12;
            B = 8'h34;
            sel = 0;
            $display("Test %0d: Hex addition (0x12 + 0x34)", test_num);
            #1;

            check_outputs(8'h46);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 8'h80;
            B = 8'h40;
            sel = 1;
            $display("Test %0d: Toggle check (0x80 - 0x40)", test_num);
            #1;

            check_outputs(8'h40);
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
        input [7:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
