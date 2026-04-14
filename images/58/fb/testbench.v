`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data;
    reg [3:0] shift_amount;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .shift_amount(shift_amount),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            data = 16'hABCD;
            shift_amount = 4'b0000;
            $display("Test %0d: No shift (SA=0000)", test_num);
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            data = 16'h0001;
            shift_amount = 4'b0010;
            $display("Test %0d: Shift by 2 (SA=0010)", test_num);
            #1;

            check_outputs(16'h0004);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            data = 16'h0001;
            shift_amount = 4'b0100;
            $display("Test %0d: Shift by 4 (SA=0100)", test_num);
            #1;

            check_outputs(16'h0010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            data = 16'h0001;
            shift_amount = 4'b0110;
            $display("Test %0d: Shift by 6 (SA=0110)", test_num);
            #1;

            check_outputs(16'h0040);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            data = 16'h0001;
            shift_amount = 4'b1000;
            $display("Test %0d: Shift by 8 (SA=1000)", test_num);
            #1;

            check_outputs(16'h0100);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            data = 16'h0001;
            shift_amount = 4'b1010;
            $display("Test %0d: Shift by 10 (SA=1010)", test_num);
            #1;

            check_outputs(16'h0400);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            data = 16'h0001;
            shift_amount = 4'b1100;
            $display("Test %0d: Shift by 12 (SA=1100)", test_num);
            #1;

            check_outputs(16'h1000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            data = 16'h0001;
            shift_amount = 4'b1110;
            $display("Test %0d: Shift by 14 (SA=1110)", test_num);
            #1;

            check_outputs(16'h4000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            data = 16'h1234;
            shift_amount = 4'b0001;
            $display("Test %0d: LSB bit 0 ignore check (SA=0001)", test_num);
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            data = 16'hFFFF;
            shift_amount = 4'b1110;
            $display("Test %0d: Full data pattern shift (SA=1110)", test_num);
            #1;

            check_outputs(16'hC000);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            data = 16'h8000;
            shift_amount = 4'b0010;
            $display("Test %0d: Shift MSB out of range (SA=0010)", test_num);
            #1;

            check_outputs(16'h0000);
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
        input [15:0] expected_out;
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
