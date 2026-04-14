`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ain;
    reg clk;
    reg reset;
    wire [3:0] count;
    wire yout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ain(ain),
        .clk(clk),
        .reset(reset),
        .count(count),
        .yout(yout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            ain = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            @(negedge clk);


            #1;



            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge clk);
            ain = 1;
            repeat (5) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd5, yout);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(posedge clk);
            ain = 1;
            repeat (3) @(posedge clk);
            ain = 0;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3, yout);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            @(posedge clk);
            ain = 1;
            repeat (16) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, yout);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            @(posedge clk);
            ain = 1;
            repeat (20) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd4, yout);
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
        input [3:0] expected_count;
        input expected_yout;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_yout === (expected_yout ^ yout ^ expected_yout)) begin
                $display("PASS");
                $display("  Outputs: count=%h, yout=%b",
                         count, yout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, yout=%b",
                         expected_count, expected_yout);
                $display("  Got:      count=%h, yout=%b",
                         count, yout);
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
        $dumpvars(0,ain, clk, reset, count, yout);
    end

endmodule
