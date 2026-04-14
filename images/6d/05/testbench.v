`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg direction;
    reg ena;
    reg reset;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .direction(direction),
        .ena(ena),
        .reset(reset),
        .q(q)
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
            ena = 0;
            direction = 0;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Up-Counting (10 cycles)", test_num);
            reset_dut();
            ena = 1;
            direction = 1;
            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clk);
            end
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Down-Counting (5 cycles)", test_num);
            reset_dut();
            ena = 1;
            direction = 0;
            for (i = 0; i < 5; i = i + 1) begin
                @(posedge clk);
            end

            #1;


            check_outputs(8'd251);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable Toggle Check", test_num);
            reset_dut();

            ena = 1;
            direction = 1;
            for (i = 0; i < 5; i = i + 1) @(posedge clk);

            ena = 0;
            for (i = 0; i < 5; i = i + 1) @(posedge clk);
            #1;

            check_outputs(8'd5);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Direction Switching", test_num);
            reset_dut();
            ena = 1;

            direction = 1;
            for (i = 0; i < 20; i = i + 1) @(posedge clk);

            direction = 0;
            for (i = 0; i < 10; i = i + 1) @(posedge clk);

            ena = 0;
            for (i = 0; i < 2; i = i + 1) @(posedge clk);

            ena = 1;
            direction = 0;
            for (i = 0; i < 2; i = i + 1) @(posedge clk);

            #1;


            check_outputs(8'd8);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Roll-over Check (256 cycles)", test_num);
            reset_dut();
            ena = 1;
            direction = 1;
            for (i = 0; i < 256; i = i + 1) @(posedge clk);
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, direction, ena, reset, q);
    end

endmodule
