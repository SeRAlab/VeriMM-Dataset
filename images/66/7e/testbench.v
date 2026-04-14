`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] a0;
    reg [4:0] a1;
    reg s;
    wire [4:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a0(a0),
        .a1(a1),
        .s(s),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select a0 (s=0)", test_num);
            a0 = 5'h0A;
            a1 = 5'h15;
            s = 1'b0;
            #1;

            check_outputs(5'h0A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select a1 (s=1)", test_num);
            a0 = 5'h0A;
            a1 = 5'h15;
            s = 1'b1;
            #1;

            check_outputs(5'h15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All zeros on a0, s=0", test_num);
            a0 = 5'h00;
            a1 = 5'h1F;
            s = 1'b0;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All ones on a1, s=1", test_num);
            a0 = 5'h00;
            a1 = 5'h1F;
            s = 1'b1;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Change a1 while s=0 (Output should remain a0)", test_num);
            a0 = 5'h12;
            a1 = 5'h00;
            s = 1'b0;
            #5;
            a1 = 5'h1F;
            #1;

            check_outputs(5'h12);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Change a0 while s=1 (Output should remain a1)", test_num);
            a0 = 5'h00;
            a1 = 5'h0B;
            s = 1'b1;
            #5;
            a0 = 5'h1F;
            #1;

            check_outputs(5'h0B);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Toggle select signal", test_num);
            a0 = 5'h11;
            a1 = 5'h0E;
            s = 1'b0;
            #5;
            s = 1'b1;
            #1;

            check_outputs(5'h0E);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Random pattern check", test_num);
            a0 = 5'h1A;
            a1 = 5'h05;
            s = 1'b0;
            #1;

            check_outputs(5'h1A);
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
        input [4:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
