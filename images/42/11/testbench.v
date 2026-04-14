`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg direction;
    reg [7:0] in;
    reg [2:0] shift_amount;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .direction(direction),
        .in(in),
        .shift_amount(shift_amount),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Left Shift by 0 (Identity)", test_num);
            in = 8'hAA;
            shift_amount = 3'd0;
            direction = 0;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Right Shift by 0 (Identity)", test_num);
            in = 8'hAA;
            shift_amount = 3'd0;
            direction = 1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Left Shift by 1", test_num);
            in = 8'h01;
            shift_amount = 3'd1;
            direction = 0;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Right Shift by 1", test_num);
            in = 8'h80;
            shift_amount = 3'd1;
            direction = 1;
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Left Shift by 4", test_num);
            in = 8'hFF;
            shift_amount = 3'd4;
            direction = 0;
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Right Shift by 4", test_num);
            in = 8'hFF;
            shift_amount = 3'd4;
            direction = 1;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Left Shift by 7 (Max Shift)", test_num);
            in = 8'h01;
            shift_amount = 3'd7;
            direction = 0;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Right Shift by 7 (Max Shift)", test_num);
            in = 8'h80;
            shift_amount = 3'd7;
            direction = 1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Left Shift Pattern 01010101 by 2", test_num);
            in = 8'h55;
            shift_amount = 3'd2;
            direction = 0;
            #1;

            check_outputs(8'h54);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Right Shift Pattern 10101010 by 2", test_num);
            in = 8'hAA;
            shift_amount = 3'd2;
            direction = 1;
            #1;

            check_outputs(8'h2A);
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
