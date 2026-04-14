`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] addr;
    reg clk;
    reg [7:0] data_in;
    reg we;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .we(we),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            addr = 0;
            data_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Basic Write and Read at Address 0x05");


            @(posedge clk);
            we = 1;
            addr = 6'h05;
            data_in = 8'hAA;


            @(posedge clk);
            we = 0;
            addr = 6'h05;


            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Boundary Check at Address 63");


            @(posedge clk);
            we = 1;
            addr = 6'd63;
            data_in = 8'hFF;


            @(posedge clk);
            we = 0;
            addr = 6'd63;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Overwrite verification at Address 0x10");


            @(posedge clk);
            we = 1;
            addr = 6'h10;
            data_in = 8'h11;


            @(posedge clk);
            we = 1;
            addr = 6'h10;
            data_in = 8'h22;


            @(posedge clk);
            we = 0;
            addr = 6'h10;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Verifying distinct addresses 0x01 and 0x02");


            @(posedge clk);
            we = 1;
            addr = 6'h01;
            data_in = 8'hCC;


            @(posedge clk);
            we = 1;
            addr = 6'h02;
            data_in = 8'hDD;


            @(posedge clk);
            we = 0;
            addr = 6'h01;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Verifying we=0 prevents writing");


            @(posedge clk);
            we = 1;
            addr = 6'h20;
            data_in = 8'h55;


            @(posedge clk);
            we = 0;
            addr = 6'h20;
            data_in = 8'h99;


            @(posedge clk);
            we = 0;
            addr = 6'h20;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55);
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
        input [7:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,addr, clk, data_in, we, data_out);
    end

endmodule
