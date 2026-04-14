`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [99:0] data;
    reg [1:0] ena;
    reg load;
    wire [99:0] q;

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
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load = 1;
            data = 100'd0;
            ena = 2'b00;
            @(posedge clk);
            #1;
            load = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            load = 1;
            data = 100'hFEDCBA9876543210FEDCBA987;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(100'hFEDCBA9876543210FEDCBA987);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            load = 1;
            data = 100'h2;
            @(posedge clk);
            #1;
            load = 0;
            ena = 2'h1;
            @(posedge clk);
            #1;
            ena = 2'h0;
            #1;

            check_outputs(100'h1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            load = 1;
            data = 100'h1;
            @(posedge clk);
            #1;
            load = 0;
            ena = 2'h1;
            @(posedge clk);
            #1;
            ena = 2'h0;

            #1;


            check_outputs(100'h8000000000000000000000000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            load = 1;
            data = 100'h1;
            @(posedge clk);
            #1;
            load = 0;
            ena = 2'h2;
            @(posedge clk);
            #1;
            ena = 2'h0;
            #1;

            check_outputs(100'h2);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            load = 1;
            data = 100'h8000000000000000000000000;
            @(posedge clk);
            #1;
            load = 0;
            ena = 2'h2;
            @(posedge clk);
            #1;
            ena = 2'h0;
            #1;

            check_outputs(100'h1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            load = 1;
            data = 100'h400;
            @(posedge clk);
            #1;
            load = 0;
            ena = 2'h1;
            repeat(10) @(posedge clk);
            #1;
            ena = 2'h0;
            #1;

            check_outputs(100'h1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            load = 1;
            data = 100'hAAAAA;
            ena = 2'h1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(100'hAAAAA);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            load = 1;
            data = 100'h55555;
            @(posedge clk);
            #1;
            load = 0;
            ena = 2'h0;
            @(posedge clk);
            ena = 2'h3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(100'h55555);
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
        input [99:0] expected_q;
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
        $dumpvars(0,clk, data, ena, load, q);
    end

endmodule
