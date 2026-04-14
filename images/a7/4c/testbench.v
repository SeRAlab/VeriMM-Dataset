`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [7:0] ldata;
    reg load;
    reg pause;
    reg reset_n;
    wire [7:0] data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .ldata(ldata),
        .load(load),
        .pause(pause),
        .reset_n(reset_n),
        .data(data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            enable = 0;
            load = 0;
            pause = 0;
            ldata = 8'h00;
            @(posedge clk);
            #1 reset_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase 001: Checking Reset Seed...");
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            ldata = 8'hA5;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            $display("Testcase 002: Checking Load 0xA5...");
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            ldata = 8'h55;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            enable = 0;
            repeat(3) @(posedge clk);
            #1;
            $display("Testcase 003: Checking Disable (Hold) logic...");
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            ldata = 8'h3C;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            enable = 1;
            pause = 1;
            repeat(3) @(posedge clk);
            #1;
            $display("Testcase 004: Checking Pause logic...");
            #1;

            check_outputs(8'h3C);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            ldata = 8'hAA;
            load = 1;
            enable = 1;
            pause = 0;
            @(posedge clk);
            #1;
            $display("Testcase 005: Checking Load Priority over Enable...");
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            ldata = 8'h01;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            enable = 1;
            pause = 0;
            @(posedge clk);
            #1;
            $display("Testcase 006: Checking LFSR step advancement from 0x01...");


            #1;



            check_outputs(8'h02);
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
        input [7:0] expected_data;
        begin
            if (expected_data === (expected_data ^ data ^ expected_data)) begin
                $display("PASS");
                $display("  Outputs: data=%h",
                         data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h",
                         expected_data);
                $display("  Got:      data=%h",
                         data);
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
        $dumpvars(0,clk, enable, ldata, load, pause, reset_n, data);
    end

endmodule
