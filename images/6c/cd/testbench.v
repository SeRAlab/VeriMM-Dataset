`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] i_0r0;
    reg [4:0] i_0r1;
    reg reset;
    wire i_0a;
    wire [4:0] o_0r0;
    wire [4:0] o_0r1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_0r0(i_0r0),
        .i_0r1(i_0r1),
        .reset(reset),
        .i_0a(i_0a),
        .o_0r0(o_0r0),
        .o_0r1(o_0r1)
    );

    // Clock generation (10ns period)
    initial begin
        reset = 0;
        forever #5 reset = ~reset;
    end

        task reset_dut;

        begin

            i_0r0 = 5'b00000;
            i_0r1 = 5'b00000;
            wait(reset == 1);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset Assertion", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 5'b00000, 5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Load Non-Zero Values", test_num);
            reset_dut();
            i_0r0 = 5'h0A;
            i_0r1 = 5'h15;
            wait(reset == 0);
            #2;
            #1;

            check_outputs(1'b1, 5'h0A, 5'h15);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Only i_0r0 Non-Zero", test_num);
            reset_dut();
            i_0r0 = 5'h1F;
            i_0r1 = 5'h00;
            wait(reset == 0);
            #2;
            #1;

            check_outputs(1'b1, 5'h1F, 5'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Only i_0r1 Non-Zero", test_num);
            reset_dut();
            i_0r0 = 5'h00;
            i_0r1 = 5'h0F;
            wait(reset == 0);
            #2;
            #1;

            check_outputs(1'b1, 5'h00, 5'h0F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: All-Zero Input Deassertion", test_num);
            reset_dut();
            i_0r0 = 5'h00;
            i_0r1 = 5'h00;
            wait(reset == 0);
            #2;
            #1;

            check_outputs(1'b0, 5'h00, 5'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Higher and Lower Bits Pattern", test_num);
            reset_dut();
            i_0r0 = 5'b11000;
            i_0r1 = 5'b00011;
            wait(reset == 0);
            #2;
            #1;

            check_outputs(1'b1, 5'b11000, 5'b00011);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Max Values (5'h1F)", test_num);
            reset_dut();
            i_0r0 = 5'h1F;
            i_0r1 = 5'h1F;
            wait(reset == 0);
            #2;
            #1;

            check_outputs(1'b1, 5'h1F, 5'h1F);
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
        input expected_i_0a;
        input [4:0] expected_o_0r0;
        input [4:0] expected_o_0r1;
        begin
            if (expected_i_0a === (expected_i_0a ^ i_0a ^ expected_i_0a) &&
                expected_o_0r0 === (expected_o_0r0 ^ o_0r0 ^ expected_o_0r0) &&
                expected_o_0r1 === (expected_o_0r1 ^ o_0r1 ^ expected_o_0r1)) begin
                $display("PASS");
                $display("  Outputs: i_0a=%b, o_0r0=%h, o_0r1=%h",
                         i_0a, o_0r0, o_0r1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: i_0a=%b, o_0r0=%h, o_0r1=%h",
                         expected_i_0a, expected_o_0r0, expected_o_0r1);
                $display("  Got:      i_0a=%b, o_0r0=%h, o_0r1=%h",
                         i_0a, o_0r0, o_0r1);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,i_0r0, i_0r1, reset, i_0a, o_0r0, o_0r1);
    end

endmodule
