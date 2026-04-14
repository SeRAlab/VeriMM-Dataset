`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg main_clk;
    reg [29:0] new_frequency;
    reg reset;
    wire new_clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .main_clk(main_clk),
        .new_frequency(new_frequency),
        .reset(reset),
        .new_clk(new_clk)
    );

    // Clock generation (10ns period)
    initial begin
        main_clk = 0;
        forever #5 main_clk = ~main_clk;
    end

        task reset_dut;

        begin
            reset = 1;
            new_frequency = 0;
            @(negedge main_clk);
            reset = 0;
            @(posedge main_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing new_frequency = 2 (Half-period = 2 cycles)", test_num);
            reset_dut();
            new_frequency = 2;

            repeat(2) @(posedge main_clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing new_frequency = 2 (Full-period = 4 cycles)", test_num);
            reset_dut();
            new_frequency = 2;

            repeat(4) @(posedge main_clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing new_frequency = 5 (Half-period = 5 cycles)", test_num);
            reset_dut();
            new_frequency = 5;
            repeat(5) @(posedge main_clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing new_frequency = 1 (Toggle every cycle)", test_num);
            reset_dut();
            new_frequency = 1;
            repeat(1) @(posedge main_clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing Reset functionality during operation", test_num);
            reset_dut();
            new_frequency = 10;
            repeat(10) @(posedge main_clk);
            #2;
            reset = 1;
            #20;
            reset = 0;
            #2;
            #1;

            check_outputs(1'b0);
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
        input expected_new_clk;
        begin
            if (expected_new_clk === (expected_new_clk ^ new_clk ^ expected_new_clk)) begin
                $display("PASS");
                $display("  Outputs: new_clk=%b",
                         new_clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_clk=%b",
                         expected_new_clk);
                $display("  Got:      new_clk=%b",
                         new_clk);
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
        $dumpvars(0,main_clk, new_frequency, reset, new_clk);
    end

endmodule
