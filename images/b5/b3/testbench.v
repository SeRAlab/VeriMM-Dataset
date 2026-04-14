`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg sig;
    wire [31:0] counter;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .sig(sig),
        .counter(counter)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            sig = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest %0d: Counting 3 simple pulses", test_num);
            reset_dut();

            repeat(3) begin
                @(negedge clk); sig = 1;
                @(negedge clk); sig = 0;
            end


            repeat(5) @(posedge clk);
            #1;

            check_outputs(32'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest %0d: Signal held high for multiple cycles", test_num);
            reset_dut();

            @(negedge clk); sig = 1;
            repeat(10) @(posedge clk);
            @(negedge clk); sig = 0;

            repeat(5) @(posedge clk);
            #1;

            check_outputs(32'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest %0d: Rapid pulsing (every 2 clock cycles)", test_num);
            reset_dut();

            repeat(10) begin
                @(negedge clk); sig = 1;
                @(negedge clk); sig = 0;
            end

            repeat(5) @(posedge clk);
            #1;

            check_outputs(32'd10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest %0d: Reset mid-operation", test_num);
            reset_dut();


            repeat(5) begin
                @(negedge clk); sig = 1;
                @(negedge clk); sig = 0;
            end


            reset = 1;
            @(posedge clk);
            reset = 0;


            repeat(2) begin
                @(negedge clk); sig = 1;
                @(negedge clk); sig = 0;
            end

            repeat(5) @(posedge clk);
            #1;

            check_outputs(32'd2);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("\nTest %0d: Burst of 100 edges", test_num);
            reset_dut();

            for(i = 0; i < 100; i = i + 1) begin
                @(negedge clk); sig = 1;
                @(negedge clk); sig = 0;
            end

            repeat(5) @(posedge clk);
            #1;

            check_outputs(32'd100);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest %0d: Signal high during reset release", test_num);
            reset = 1;
            sig = 1;
            @(posedge clk);
            #1 reset = 0;



            repeat(5) @(posedge clk);

            @(negedge clk); sig = 0;
            repeat(2) @(posedge clk);
            @(negedge clk); sig = 1;

            repeat(5) @(posedge clk);
            #1;

            check_outputs(32'd1);
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
        input [31:0] expected_counter;
        begin
            if (expected_counter === (expected_counter ^ counter ^ expected_counter)) begin
                $display("PASS");
                $display("  Outputs: counter=%h",
                         counter);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter=%h",
                         expected_counter);
                $display("  Got:      counter=%h",
                         counter);
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
        $dumpvars(0,clk, reset, sig, counter);
    end

endmodule
