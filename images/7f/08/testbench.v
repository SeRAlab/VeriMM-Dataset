`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg [2:0] shift_amount;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .shift_amount(shift_amount),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        data_in = 8'h00;
        shift_amount = 3'd0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Test %0d: Shift Left by 0", test_num);
        data_in = 8'hAA;
        shift_amount = 3'd0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Test %0d: Shift Left by 1", test_num);
        data_in = 8'h01;
        shift_amount = 3'd1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'h02);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Test %0d: Shift Left by 7", test_num);
        data_in = 8'h01;
        shift_amount = 3'd7;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Test %0d: Shift bits out (Overflow)", test_num);
        data_in = 8'hC0;
        shift_amount = 3'd2;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Test %0d: Shift FF by 4", test_num);
        data_in = 8'hFF;
        shift_amount = 3'd4;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'hF0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Test %0d: Pattern shift 0xA5 by 2", test_num);
        data_in = 8'hA5;
        shift_amount = 3'd2;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'h94);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        $display("Test %0d: Shift zeros", test_num);
        data_in = 8'h00;
        shift_amount = 3'd5;
        @(posedge clk);
        #2;
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
        input [7:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, shift_amount, data_out);
    end

endmodule
