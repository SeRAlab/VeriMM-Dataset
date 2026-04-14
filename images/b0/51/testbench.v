`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg enable;
    reg reset;
    reg transparent_enable;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .reset(reset),
        .transparent_enable(transparent_enable),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            transparent_enable = 0;
            data_in = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(32'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            enable = 1;
            transparent_enable = 0;
            data_in = 32'hAAAA_BBBB;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hAAAA_BBBB);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            enable = 1;
            transparent_enable = 0;
            data_in = 32'h1234_5678;
            @(posedge clk);
            #2;

            enable = 0;
            data_in = 32'hFFFF_FFFF;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            transparent_enable = 1;
            enable = 0;
            data_in = 32'hCAFE_BABE;
            #5;

            #1;


            check_outputs(32'hCAFE_BABE);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            transparent_enable = 1;
            data_in = 32'h1111_1111;
            #5;
            data_in = 32'h2222_2222;
            #5;
            #1;

            check_outputs(32'h2222_2222);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            transparent_enable = 1;
            data_in = 32'hDADA_DADA;
            #5;

            transparent_enable = 0;
            enable = 0;
            data_in = 32'h0000_0000;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hDADA_DADA);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            enable = 1;
            transparent_enable = 0;
            data_in = 32'h8888_7777;
            @(posedge clk);
            #1;
            data_in = 32'h0000_0000;
            #1;

            #1;


            check_outputs(32'h8888_7777);
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
        input [31:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, enable, reset, transparent_enable, data_out);
    end

endmodule
