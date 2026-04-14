`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] p;
    reg [3:0] q;
    wire [3:0] out_shift_left;
    wire [3:0] out_shift_right;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .p(p),
        .q(q),
        .out_shift_left(out_shift_left),
        .out_shift_right(out_shift_right)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Inputs (p=0, q=0)", test_num);
            p = 4'b0000;
            q = 4'b0000;
            #1;

            check_outputs(4'b0000, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Shift In (p=1, q=8)", test_num);
            p = 4'b0001;
            q = 4'b1000;
            #1;

            check_outputs(4'b0010, 4'b0100);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bits shifting out (p=8, q=1)", test_num);
            p = 4'b1000;
            q = 4'b0001;
            #1;

            check_outputs(4'b0000, 4'b0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All bits set (p=15, q=15)", test_num);
            p = 4'b1111;
            q = 4'b1111;
            #1;

            check_outputs(4'b1110, 4'b0111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bits A (p=10, q=5)", test_num);
            p = 4'b1010;
            q = 4'b0101;
            #1;

            check_outputs(4'b0100, 4'b0010);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bits B (p=5, q=10)", test_num);
            p = 4'b0101;
            q = 4'b1010;
            #1;

            check_outputs(4'b1010, 4'b0101);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Middle bits (p=6, q=6)", test_num);
            p = 4'b0110;
            q = 4'b0110;
            #1;

            check_outputs(4'b1100, 4'b0011);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complex pattern (p=11, q=13)", test_num);
            p = 4'b1011;
            q = 4'b1101;
            #1;

            check_outputs(4'b0110, 4'b0110);
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
        input [3:0] expected_out_shift_left;
        input [3:0] expected_out_shift_right;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_shift_left === (expected_out_shift_left ^ out_shift_left ^ expected_out_shift_left) &&
                expected_out_shift_right === (expected_out_shift_right ^ out_shift_right ^ expected_out_shift_right)) begin
                $display("PASS");
                $display("  Outputs: out_shift_left=%h, out_shift_right=%h",
                         out_shift_left, out_shift_right);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_shift_left=%h, out_shift_right=%h",
                         expected_out_shift_left, expected_out_shift_right);
                $display("  Got:      out_shift_left=%h, out_shift_right=%h",
                         out_shift_left, out_shift_right);
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
