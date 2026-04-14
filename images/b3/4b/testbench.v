`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in_temp;
    reg rst;
    reg [7:0] set_temp;
    wire [7:0] fan_speed;
    wire over_temp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_temp(in_temp),
        .rst(rst),
        .set_temp(set_temp),
        .fan_speed(fan_speed),
        .over_temp(over_temp)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            in_temp = 0;
            set_temp = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(8'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            in_temp = 8'd60;
            set_temp = 8'd40;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd20, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            in_temp = 8'd30;
            set_temp = 8'd50;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            in_temp = 8'd50;
            set_temp = 8'd50;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            in_temp = 8'd150;
            set_temp = 8'd50;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd255, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            in_temp = 8'd200;
            set_temp = 8'd20;
            @(posedge clk);

            rst = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            in_temp = 8'd80;
            set_temp = 8'd40;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd40, 1'b0);
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
        input [7:0] expected_fan_speed;
        input expected_over_temp;
        begin
            if (expected_fan_speed === (expected_fan_speed ^ fan_speed ^ expected_fan_speed) &&
                expected_over_temp === (expected_over_temp ^ over_temp ^ expected_over_temp)) begin
                $display("PASS");
                $display("  Outputs: fan_speed=%h, over_temp=%b",
                         fan_speed, over_temp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fan_speed=%h, over_temp=%b",
                         expected_fan_speed, expected_over_temp);
                $display("  Got:      fan_speed=%h, over_temp=%b",
                         fan_speed, over_temp);
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
        $dumpvars(0,clk, in_temp, rst, set_temp, fan_speed, over_temp);
    end

endmodule
