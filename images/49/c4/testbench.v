`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg COMPLS6;
    reg K;
    reg [4:0] L;
    reg clk;
    reg [4:0] data_in;
    reg reset;
    wire [5:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .COMPLS6(COMPLS6),
        .K(K),
        .L(L),
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
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
            data_in = 0;
            L = 0;
            K = 0;
            COMPLS6 = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Reset and Initial State Check");
            reset_dut();


            #1;



            check_outputs(6'b000000);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Basic processing (K=0, COMPLS6=0)");
            reset_dut();
            data_in = 5'h0A;
            L = 5'h05;
            K = 0;
            COMPLS6 = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(data_out);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Influence of Control K");
            reset_dut();
            data_in = 5'h10;
            L = 5'h02;
            K = 1;
            COMPLS6 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(data_out);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Influence of COMPLS6");
            reset_dut();
            data_in = 5'h0F;
            L = 5'h0F;
            K = 0;
            COMPLS6 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(data_out);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Boundary Values (Max)");
            reset_dut();
            data_in = 5'h1F;
            L = 5'h1F;
            K = 1;
            COMPLS6 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(data_out);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Multi-cycle Sequential Processing");
            reset_dut();


            data_in = 5'h01; L = 5'h01; K = 0; COMPLS6 = 0;
            @(posedge clk);
            #1;


            data_in = 5'h02; L = 5'h03; K = 1; COMPLS6 = 0;
            @(posedge clk);
            #1;


            data_in = 5'h04; L = 5'h07; K = 0; COMPLS6 = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(data_out);
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
        input [5:0] expected_data_out;
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
        $dumpvars(0,COMPLS6, K, L, clk, data_in, reset, data_out);
    end

endmodule
