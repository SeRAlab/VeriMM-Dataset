`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] duty_cycle;
    reg [31:0] modulus;
    reg reset;
    wire out_clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .duty_cycle(duty_cycle),
        .modulus(modulus),
        .reset(reset),
        .out_clk(out_clk)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            modulus = 100;
            duty_cycle = 128;
            reset_dut();
            repeat(10) @(posedge clk);
            #1 #1;
 check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            modulus = 100;
            duty_cycle = 128;
            reset_dut();
            repeat(60) @(posedge clk);
            #1 #1;
 check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            modulus = 40;
            duty_cycle = 64;
            reset_dut();
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            modulus = 40;
            duty_cycle = 64;
            reset_dut();
            repeat(20) @(posedge clk);
            #1 #1;
 check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            modulus = 20;
            duty_cycle = 192;
            reset_dut();
            repeat(12) @(posedge clk);
            #1 #1;
 check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            modulus = 20;
            duty_cycle = 192;
            reset_dut();
            repeat(18) @(posedge clk);
            #1 #1;
 check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            modulus = 50;
            duty_cycle = 0;
            reset_dut();
            repeat(10) @(posedge clk);
            #1 #1;
 check_outputs(0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            modulus = 10;
            duty_cycle = 255;
            reset_dut();
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            modulus = 10;
            duty_cycle = 255;
            reset_dut();
            repeat(10) @(posedge clk);
            #1 #1;
 check_outputs(0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            modulus = 10;
            duty_cycle = 128;
            reset_dut();
            repeat(11) @(posedge clk);
            #1 #1;
 check_outputs(1);
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
        input expected_out_clk;
        begin
            if (expected_out_clk === (expected_out_clk ^ out_clk ^ expected_out_clk)) begin
                $display("PASS");
                $display("  Outputs: out_clk=%b",
                         out_clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_clk=%b",
                         expected_out_clk);
                $display("  Got:      out_clk=%b",
                         out_clk);
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
        $dumpvars(0,clk, duty_cycle, modulus, reset, out_clk);
    end

endmodule
