`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A;
    reg B;
    reg SEL;
    reg clk;
    reg [99:0] data;
    reg [1:0] ena;
    reg load;
    reg reset;
    wire [99:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .SEL(SEL),
        .clk(clk),
        .data(data),
        .ena(ena),
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
            reset = 1;
            load = 0;
            ena = 2'b00;
            data = 100'b0;
            A = 0; B = 0; SEL = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Checking Reset...");
            reset_dut();
            #1;

            check_outputs(100'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Checking Load...");
            reset_dut();
            load = 1;
            data = 100'hFEDCBA9876543210FEDCBA9876543210;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(100'hFEDCBA9876543210FEDCBA9876543210);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Shift Left (ena=2'b10) with Mux A...");
            reset_dut();
            load = 1;
            data = 100'h1;
            @(posedge clk);
            #1 load = 0;
            ena = 2'b10;
            SEL = 0; A = 1;
            @(posedge clk);
            #1 ena = 2'b00;

            #1;


            check_outputs(100'h3);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Shift Right (ena=2'b01) with Mux B...");
            reset_dut();
            load = 1;
            data = 100'h8000000000000000000000000;
            @(posedge clk);
            #1 load = 0;
            ena = 2'b01;
            SEL = 1; B = 1;
            @(posedge clk);
            #1 ena = 2'b00;


            #1;



            check_outputs(100'hC000000000000000000000000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Checking Hold (ena=2'b00)...");
            reset_dut();
            load = 1;
            data = 100'h5555555555555555555555555;
            @(posedge clk);
            #1 load = 0;
            ena = 2'b00;
            A = 1; B = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(100'h5555555555555555555555555);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Checking Load Priority over Ena...");
            reset_dut();
            load = 1;
            data = 100'hFFFFFFFFFFFFFFFFFFFFFFFFF;
            ena = 2'b01;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(100'hFFFFFFFFFFFFFFFFFFFFFFFFF);
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
        $dumpvars(0,A, B, SEL, clk, data, ena, load, reset, q);
    end

endmodule
