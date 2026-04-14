`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] in;
    reg reset;
    wire down;
    wire rise;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .down(down),
        .rise(rise),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in = 32'h0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(0, 0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Bit Rising Edge", test_num);
            reset_dut();
            in = 32'h0;
            @(posedge clk);
            in = 32'h00000001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Single Bit Falling Edge", test_num);
            reset_dut();
            in = 32'h00000001;
            @(posedge clk);
            #1;
            in = 32'h00000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: All Bits Rising Edge", test_num);
            reset_dut();
            in = 32'h00000000;
            @(posedge clk);
            in = 32'hFFFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: All Bits Falling Edge", test_num);
            reset_dut();
            in = 32'hFFFFFFFF;
            @(posedge clk);
            #1;
            in = 32'h00000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Simultaneous Rise and Fall", test_num);
            reset_dut();
            in = 32'h00000001;
            @(posedge clk);
            #1;
            in = 32'h80000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 1, 2'b11);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Steady State High", test_num);
            reset_dut();
            in = 32'hAAAAAAAA;
            @(posedge clk);
            #1;
            in = 32'hAAAAAAAA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 2'b00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Sequential Toggles", test_num);
            reset_dut();
            in = 32'h0;
            @(posedge clk);
            in = 32'hF0F0F0F0;
            @(posedge clk);
            #1;
            in = 32'h0F0F0F0F;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 1, 2'b11);
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
        input expected_down;
        input expected_rise;
        input [1:0] expected_state;
        begin
            if (expected_down === (expected_down ^ down ^ expected_down) &&
                expected_rise === (expected_rise ^ rise ^ expected_rise) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: down=%b, rise=%b, state=%h",
                         down, rise, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: down=%b, rise=%b, state=%h",
                         expected_down, expected_rise, expected_state);
                $display("  Got:      down=%b, rise=%b, state=%h",
                         down, rise, state);
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
        $dumpvars(0,clk, in, reset, down, rise, state);
    end

endmodule
