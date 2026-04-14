`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [99:0] data;
    reg [1:0] ena;
    reg load;
    reg [7:0] num1;
    reg [7:0] num2;
    reg reset;
    wire [99:0] rot;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .ena(ena),
        .load(load),
        .num1(num1),
        .num2(num2),
        .reset(reset),
        .rot(rot),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            ena = 0;
            num1 = 0;
            num2 = 0;
            data = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(100'd0, 8'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            num1 = 8'd15;
            num2 = 8'd27;
            data = 100'hA5A5A5A5A5A5A5A5A5A5A5A5A;
            load = 1;

            #1;


            check_outputs(100'hA5A5A5A5A5A5A5A5A5A5A5A5A, 8'd42);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            data = 100'h1;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            ena = 2'b01;

            #1;


            check_outputs({1'b1, 99'b0}, 8'd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            data = 100'hFF;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            ena = 2'b10;

            #1;


            check_outputs({8'hFF, 92'h0}, 8'd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            num1 = 8'd250;
            num2 = 8'd10;
            load = 1;

            #1;


            check_outputs(100'd0, 8'd4);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            data = 100'h8000000000000000000000000;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            ena = 2'b01;
            @(posedge clk);
            @(posedge clk);
            ena = 2'b10;



            #1;




            check_outputs({10'b0, 1'b1, 89'b0}, 8'd0);
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
        input [99:0] expected_rot;
        input [7:0] expected_sum;
        begin
            if (expected_rot === (expected_rot ^ rot ^ expected_rot) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: rot=%h, sum=%h",
                         rot, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rot=%h, sum=%h",
                         expected_rot, expected_sum);
                $display("  Got:      rot=%h, sum=%h",
                         rot, sum);
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
        $dumpvars(0,clk, data, ena, load, num1, num2, reset, rot, sum);
    end

endmodule
