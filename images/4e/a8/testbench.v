`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg [1:0] Sel;
    wire [15:0] Result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Sel(Sel),
        .Result(Result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition (10 + 20)", test_num);
            A = 16'sd10;
            B = 16'sd20;
            Sel = 2'b00;
            #1;

            check_outputs(16'sd30);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition (-15 + 5)", test_num);
            A = -16'sd15;
            B = 16'sd5;
            Sel = 2'b00;
            #1;

            check_outputs(-16'sd10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Subtraction (100 - 40)", test_num);
            A = 16'sd100;
            B = 16'sd40;
            Sel = 2'b01;
            #1;

            check_outputs(16'sd60);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Subtraction (10 - 25)", test_num);
            A = 16'sd10;
            B = 16'sd25;
            Sel = 2'b01;
            #1;

            check_outputs(-16'sd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiplication (12 * 11)", test_num);
            A = 16'sd12;
            B = 16'sd11;
            Sel = 2'b10;
            #1;

            check_outputs(16'sd132);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiplication (-5 * 4)", test_num);
            A = -16'sd5;
            B = 16'sd4;
            Sel = 2'b10;
            #1;

            check_outputs(-16'sd20);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Division (100 / 10)", test_num);
            A = 16'sd100;
            B = 16'sd10;
            Sel = 2'b11;
            #1;

            check_outputs(16'sd10);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Division (-50 / 5)", test_num);
            A = -16'sd50;
            B = 16'sd5;
            Sel = 2'b11;
            #1;

            check_outputs(-16'sd10);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Division by Zero (50 / 0)", test_num);
            A = 16'sd50;
            B = 16'sd0;
            Sel = 2'b11;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition Overflow (32767 + 1)", test_num);
            A = 16'sh7FFF;
            B = 16'sh0001;
            Sel = 2'b00;
            #1;

            check_outputs(16'sh8000);
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
        input [15:0] expected_Result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Result === (expected_Result ^ Result ^ expected_Result)) begin
                $display("PASS");
                $display("  Outputs: Result=%h",
                         Result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Result=%h",
                         expected_Result);
                $display("  Got:      Result=%h",
                         Result);
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
