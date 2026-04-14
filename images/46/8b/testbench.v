`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    wire [7:0] out_shift_left;
    wire [7:0] out_shift_right;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out_shift_left(out_shift_left),
        .out_shift_right(out_shift_right)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: All zeros", test_num);
            in = 8'h00;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: All ones", test_num);
            in = 8'hFF;
            #1;

            check_outputs(8'hFE, 8'h7F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: MSB only", test_num);
            in = 8'h80;
            #1;

            check_outputs(8'h00, 8'h40);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: LSB only", test_num);
            in = 8'h01;
            #1;

            check_outputs(8'h02, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Alternating pattern 0101...", test_num);
            in = 8'h55;
            #1;

            check_outputs(8'hAA, 8'h2A);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Alternating pattern 1010...", test_num);
            in = 8'hAA;
            #1;

            check_outputs(8'h54, 8'h55);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Middle bits set", test_num);
            in = 8'h18;
            #1;

            check_outputs(8'h30, 8'h0C);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Lower nibble set", test_num);
            in = 8'h0F;
            #1;

            check_outputs(8'h1E, 8'h07);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("\nTestcase %0d: Upper nibble set", test_num);
            in = 8'hF0;
            #1;

            check_outputs(8'hE0, 8'h78);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("\nTestcase %0d: Random pattern C3", test_num);
            in = 8'hC3;
            #1;

            check_outputs(8'h86, 8'h61);
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
        input [7:0] expected_out_shift_left;
        input [7:0] expected_out_shift_right;
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
