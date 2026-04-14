`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg j;
    reg k;
    reg l;
    reg m;
    wire out_pos;
    wire out_sop;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .j(j),
        .k(k),
        .l(l),
        .m(m),
        .out_pos(out_pos),
        .out_sop(out_sop)
    );
    task testcase001;

        begin
            $display("Test Case 001: Input = 0 (0000)");
            j = 0; k = 0; l = 0; m = 0;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Input = 1 (0001)");
            j = 0; k = 0; l = 0; m = 1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Input = 2 (0010)");
            j = 0; k = 0; l = 1; m = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Input = 4 (0100)");
            j = 0; k = 1; l = 0; m = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Input = 7 (0111)");
            j = 0; k = 1; l = 1; m = 1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Input = 8 (1000)");
            j = 1; k = 0; l = 0; m = 0;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Input = 9 (1001)");
            j = 1; k = 0; l = 0; m = 1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Input = 10 (1010)");
            j = 1; k = 0; l = 1; m = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            $display("Test Case 009: Input = 12 (1100)");
            j = 1; k = 1; l = 0; m = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            $display("Test Case 010: Input = 14 (1110)");
            j = 1; k = 1; l = 1; m = 0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase011;

        begin
            $display("Test Case 011: Input = 15 (1111)");
            j = 1; k = 1; l = 1; m = 1;
            #1;

            check_outputs(1'b1, 1'b1);
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
        input expected_out_pos;
        input expected_out_sop;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_pos === (expected_out_pos ^ out_pos ^ expected_out_pos) &&
                expected_out_sop === (expected_out_sop ^ out_sop ^ expected_out_sop)) begin
                $display("PASS");
                $display("  Outputs: out_pos=%b, out_sop=%b",
                         out_pos, out_sop);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_pos=%b, out_sop=%b",
                         expected_out_pos, expected_out_sop);
                $display("  Got:      out_pos=%b, out_sop=%b",
                         out_pos, out_sop);
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
