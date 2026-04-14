`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ctrl;
    reg [7:0] in;
    reg [3:0] shift_amt;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .in(in),
        .shift_amt(shift_amt),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Left Shift (ctrl=00) - Basic", test_num);
            in = 8'b00001111;
            ctrl = 2'b00;
            shift_amt = 4'd2;
            #1;

            check_outputs(8'b00111100);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Left Shift (ctrl=00) - Overflow", test_num);
            in = 8'b10101010;
            ctrl = 2'b00;
            shift_amt = 4'd4;
            #1;

            check_outputs(8'b10100000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Logical Right Shift (ctrl=01) - Basic", test_num);
            in = 8'b11110000;
            ctrl = 2'b01;
            shift_amt = 4'd4;
            #1;

            check_outputs(8'b00001111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Logical Right Shift (ctrl=01) - MSB Zero Fill", test_num);
            in = 8'b10000000;
            ctrl = 2'b01;
            shift_amt = 4'd1;
            #1;

            check_outputs(8'b01000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Arithmetic Right Shift (ctrl=10) - Positive", test_num);
            in = 8'b01100000;
            ctrl = 2'b10;
            shift_amt = 4'd2;
            #1;

            check_outputs(8'b00011000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Arithmetic Right Shift (ctrl=10) - Negative", test_num);
            in = 8'b10000000;
            ctrl = 2'b10;
            shift_amt = 4'd2;
            #1;

            check_outputs(8'b11100000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift Amount Zero", test_num);
            in = 8'hA5;
            ctrl = 2'b00;
            shift_amt = 4'd0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Arithmetic Right Shift - Large Shift Negative", test_num);
            in = 8'b10101010;
            ctrl = 2'b10;
            shift_amt = 4'd8;
            #1;

            check_outputs(8'b11111111);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Logical Right Shift - Shift All Out", test_num);
            in = 8'hFF;
            ctrl = 2'b01;
            shift_amt = 4'd8;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Left Shift - Shift All Out", test_num);
            in = 8'hFF;
            ctrl = 2'b00;
            shift_amt = 4'd8;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
