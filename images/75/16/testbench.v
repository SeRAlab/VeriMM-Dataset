`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg clk;
    reg [7:0] num;
    reg reset;
    wire [7:0] count;
    wire down;
    wire pulse;
    wire rise;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .clk(clk),
        .num(num),
        .reset(reset),
        .count(count),
        .down(down),
        .pulse(pulse),
        .rise(rise)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0;
            num = 8'hFF;
            reset = 1;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(8'd0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            a = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'd0, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            a = 1;
            @(posedge clk);
            #2;
            a = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'd0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            num = 8'd130;
            @(posedge clk);
            #2;
            num = 8'd100;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'd1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            num = 8'd127;
            @(posedge clk);
            #2;
            num = 8'd126;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            num = 8'd150; @(posedge clk); #2;
            num = 8'd50;  @(posedge clk); #2;

            num = 8'd200; @(posedge clk); #2;

            num = 8'd10;  @(posedge clk); #2;
            #1;

            check_outputs(8'd2, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            num = 8'd150;
            @(posedge clk); #2;
            num = 8'd80;
            @(posedge clk); #2;
            @(posedge clk); #2;
            @(posedge clk); #2;
            #1;

            check_outputs(8'd1, 1'b0, 1'b1, 1'b0);
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
        input [7:0] expected_count;
        input expected_down;
        input expected_pulse;
        input expected_rise;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_down === (expected_down ^ down ^ expected_down) &&
                expected_pulse === (expected_pulse ^ pulse ^ expected_pulse) &&
                expected_rise === (expected_rise ^ rise ^ expected_rise)) begin
                $display("PASS");
                $display("  Outputs: count=%h, down=%b, pulse=%b, rise=%b",
                         count, down, pulse, rise);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, down=%b, pulse=%b, rise=%b",
                         expected_count, expected_down, expected_pulse, expected_rise);
                $display("  Got:      count=%h, down=%b, pulse=%b, rise=%b",
                         count, down, pulse, rise);
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
        $dumpvars(0,a, clk, num, reset, count, down, pulse, rise);
    end

endmodule
