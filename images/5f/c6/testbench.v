`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [3:0] shift;
    wire [15:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .shift(shift),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: No shift (shift=0)", test_num);
            A = 16'hABCD;
            shift = 4'd0;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift by 1 (bit 0)", test_num);
            A = 16'hFFFF;
            shift = 4'd1;
            #1;

            check_outputs(16'h7FFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift by 2 (bit 1)", test_num);
            A = 16'hFFFF;
            shift = 4'd2;
            #1;

            check_outputs(16'h3FFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift by 4 (bit 2)", test_num);
            A = 16'hFFFF;
            shift = 4'd4;
            #1;

            check_outputs(16'h0FFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift by 8 (bit 3)", test_num);
            A = 16'hFFFF;
            shift = 4'd8;
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Composite shift (shift=3, bits 0 and 1)", test_num);
            A = 16'hAAAA;
            shift = 4'd3;
            #1;

            check_outputs(16'h1555);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Composite shift (shift=7, bits 0, 1, 2)", test_num);
            A = 16'hF0F0;
            shift = 4'd7;
            #1;

            check_outputs(16'h01E1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum shift (shift=15)", test_num);
            A = 16'h8000;
            shift = 4'd15;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift out all bits", test_num);
            A = 16'h0001;
            shift = 4'd1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data pattern manipulation", test_num);
            A = 16'h1234;
            shift = 4'd4;
            #1;

            check_outputs(16'h0123);
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
        input [15:0] expected_Y;
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
