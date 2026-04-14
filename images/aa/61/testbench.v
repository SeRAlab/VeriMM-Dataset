`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data;
    reg load;
    reg [1:0] shift;
    reg up_down;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .load(load),
        .shift(shift),
        .up_down(up_down),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(posedge clk);
        load = 1;
        data = 4'b0000;
        shift = 2'b00;
        up_down = 0;
        @(posedge clk);
        #1;
        load = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        @(posedge clk);
        load = 1;
        data = 4'b1010;
        @(posedge clk);
        load = 0;
        shift = 2'b00;
        #1;
        $display("Test Case 001: Load 10, No Shift");
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();

        up_down = 1;
        @(posedge clk);
        @(posedge clk);
        shift = 2'b00;
        #1;
        $display("Test Case 002: Count Up to 2, No Shift");
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();

        load = 1; data = 4'b0101;
        @(posedge clk);
        load = 0; up_down = 0;
        @(posedge clk);
        shift = 2'b00;
        #1;
        $display("Test Case 003: Load 5, Count Down to 4, No Shift");
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();

        load = 1; data = 4'b0011;
        @(posedge clk);
        load = 0; up_down = 1;
        @(posedge clk);
        shift = 2'b01;
        #1;
        $display("Test Case 004: Count to 4, Left Shift 1");
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();

        load = 1; data = 4'b0111;
        @(posedge clk);
        load = 0; up_down = 0;
        @(posedge clk);
        shift = 2'b10;
        #1;
        $display("Test Case 005: Count to 6, Right Shift 1");
        #1;

        check_outputs(4'b0011);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();

        load = 1; data = 4'b0001;
        @(posedge clk);
        load = 0; up_down = 1;
        @(posedge clk);
        shift = 2'b11;
        #1;
        $display("Test Case 006: Count to 2, Left Shift 2");
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();

        load = 1; data = 4'b1111;
        @(posedge clk);
        load = 0; up_down = 1;
        @(posedge clk);
        shift = 2'b00;
        #1;
        $display("Test Case 007: Wrap Up (15 to 0)");
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();

        load = 1; data = 4'b0000;
        @(posedge clk);
        load = 0; up_down = 0;
        @(posedge clk);
        shift = 2'b00;
        #1;
        $display("Test Case 008: Wrap Down (0 to 15)");
        #1;

        check_outputs(4'b1111);
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
        input [3:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,clk, data, load, shift, up_down, result);
    end

endmodule
