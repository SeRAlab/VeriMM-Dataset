`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg load;
    reg reset;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .load(load),
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
            load = 0;
            d = 8'h00;
            @(posedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Basic Reset", test_num);
            reset_dut();


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Load 0xAA", test_num);
            reset_dut();
            @(posedge clk);
            d = 8'hAA;
            load = 1;
            @(posedge clk);
            load = 0;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Load 0x55 and Hold", test_num);
            reset_dut();
            @(posedge clk);
            d = 8'h55;
            load = 1;
            @(posedge clk);
            load = 0;
            d = 8'hFF;
            @(posedge clk);
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Reset Priority Over Load", test_num);
            reset_dut();
            @(posedge clk);
            d = 8'h12;
            load = 1;
            @(posedge clk);
            reset = 1;
            d = 8'h34;
            load = 1;
            @(posedge clk);
            reset = 0;
            load = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Consecutive Loads", test_num);
            reset_dut();
            @(posedge clk);
            d = 8'h11;
            load = 1;
            @(posedge clk);
            d = 8'h22;
            @(posedge clk);
            d = 8'h33;
            @(posedge clk);
            load = 0;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Load Zero Value", test_num);
            reset_dut();
            @(posedge clk);
            d = 8'hFF;
            load = 1;
            @(posedge clk);
            d = 8'h00;
            @(posedge clk);
            load = 0;
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
        $dumpvars(0,clk, d, load, reset, q);
    end

endmodule
