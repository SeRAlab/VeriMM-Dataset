`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] data;
    reg enable;
    reg load;
    wire [511:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .enable(enable),
        .load(load),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            load = 1;
            enable = 0;
            data = 512'b0;
            @(negedge clk);
            load = 0;
        end
        endtask
    task testcase001;

        reg [511:0] load_val;
        begin
            reset_dut();
            load_val = 512'h55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555;
            @(negedge clk);
            load = 1;
            data = load_val;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(load_val);
        end
        endtask

    task testcase002;

        reg [511:0] initial_val;
        reg [511:0] expected_val;
        begin
            reset_dut();

            initial_val = 512'h4;




            expected_val = 512'hA;

            @(negedge clk);
            load = 1;
            data = initial_val;
            @(negedge clk);
            load = 0;
            enable = 1;
            @(negedge clk);
            enable = 0;
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase003;

        reg [511:0] initial_val;
        reg [511:0] expected_val;
        begin
            reset_dut();

            initial_val = (512'h1 << 511) | 512'h1;






            expected_val = (512'h1 << 510) | 512'h2;

            @(negedge clk);
            load = 1;
            data = initial_val;
            @(negedge clk);
            load = 0;
            enable = 1;
            @(negedge clk);
            enable = 0;
            #1;

            check_outputs(expected_val);
        end
        endtask

    task testcase004;

        reg [511:0] initial_val;
        begin
            reset_dut();
            initial_val = 512'hDEADBEEF;
            @(negedge clk);
            load = 1;
            data = initial_val;
            @(negedge clk);
            load = 0;
            enable = 0;
            repeat (5) @(negedge clk);
            #1;

            check_outputs(initial_val);
        end
        endtask

    task testcase005;

        reg [511:0] initial_val;
        reg [511:0] expected_val;
        begin
            reset_dut();
            initial_val = 512'h1;



            expected_val = 512'h5;

            @(negedge clk);
            load = 1;
            data = initial_val;
            @(negedge clk);
            load = 0;
            enable = 1;
            repeat (2) @(negedge clk);
            enable = 0;
            #1;

            check_outputs(expected_val);
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
        input [511:0] expected_q;
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
        $dumpvars(0,clk, data, enable, load, q);
    end

endmodule
