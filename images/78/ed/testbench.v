`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] load_value;
    reg reset;
    reg shift_dir;
    reg [3:0] shift_value;
    reg up_down;
    wire [3:0] RESULT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .load_value(load_value),
        .reset(reset),
        .shift_dir(shift_dir),
        .shift_value(shift_value),
        .up_down(up_down),
        .RESULT(RESULT)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load_value = 4'b0000;
            shift_value = 4'b0000;
            up_down = 0;
            shift_dir = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset and Initial Load Value", test_num);
            reset = 1;
            load_value = 4'b1010;
            @(posedge clk);
            #1 reset = 0;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Counting Up", test_num);
            reset_dut();
            up_down = 1;
            repeat(3) @(posedge clk);
            #1 #1;
 check_outputs(4'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Counting Down", test_num);
            reset = 1;
            load_value = 4'd5;
            @(posedge clk);
            #1 reset = 0;
            up_down = 0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(4'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Counter Wrap-around (15 to 0)", test_num);
            reset = 1;
            load_value = 4'd15;
            @(posedge clk);
            #1 reset = 0;
            up_down = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Shift Left Operation", test_num);
            reset_dut();
            shift_value = 4'b0011;
            shift_dir = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0110);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Shift Right Operation", test_num);
            reset_dut();
            shift_value = 4'b1100;
            shift_dir = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0110);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Counter Wrap-around (0 to 15)", test_num);
            reset_dut();
            up_down = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd15);
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
        input [3:0] expected_RESULT;
        begin
            if (expected_RESULT === (expected_RESULT ^ RESULT ^ expected_RESULT)) begin
                $display("PASS");
                $display("  Outputs: RESULT=%h",
                         RESULT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RESULT=%h",
                         expected_RESULT);
                $display("  Got:      RESULT=%h",
                         RESULT);
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
        $dumpvars(0,clk, load_value, reset, shift_dir, shift_value, up_down, RESULT);
    end

endmodule
