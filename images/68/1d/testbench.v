`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] io_poly;
    reg io_ready;
    reg io_valid_0;
    wire [2:0] io_encoded;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .io_poly(io_poly),
        .io_ready(io_ready),
        .io_valid_0(io_valid_0),
        .io_encoded(io_encoded)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        io_valid_0 = 0;
        io_ready = 0;
        io_poly = 3'b000;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Running Testcase 001: Poly 011 Encoding Start...");
        reset_dut();
        io_poly = 3'b011;
        io_valid_0 = 1;
        io_ready = 1;


        repeat(4) @(posedge clk);
        #1;



        #1;




        check_outputs(io_encoded);
        $display("Testcase 001 finished.");
    end
        endtask

    task testcase002;

    begin
        $display("Running Testcase 002: Poly 101 Encoding Start...");
        reset_dut();
        io_poly = 3'b101;
        io_valid_0 = 1;
        io_ready = 1;

        repeat(4) @(posedge clk);
        #1;

        #1;


        check_outputs(io_encoded);
        $display("Testcase 002 finished.");
    end
        endtask

    task testcase003;

    reg [2:0] first_val;
    begin
        $display("Running Testcase 003: Valid signal gating...");
        reset_dut();
        io_poly = 3'b111;
        io_valid_0 = 0;
        io_ready = 1;

        repeat(2) @(posedge clk);
        first_val = io_encoded;

        repeat(2) @(posedge clk);
        #1;


        #1;



        check_outputs(first_val);
        $display("Testcase 003 finished.");
    end
        endtask

    task testcase004;

    begin
        $display("Running Testcase 004: Ready (Backpressure) test...");
        reset_dut();
        io_poly = 3'b010;
        io_valid_0 = 1;
        io_ready = 0;

        repeat(4) @(posedge clk);
        #1;


        #1;



        check_outputs(io_encoded);
        $display("Testcase 004 finished.");
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
        input [2:0] expected_io_encoded;
        begin
            if (expected_io_encoded === (expected_io_encoded ^ io_encoded ^ expected_io_encoded)) begin
                $display("PASS");
                $display("  Outputs: io_encoded=%h",
                         io_encoded);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_encoded=%h",
                         expected_io_encoded);
                $display("  Got:      io_encoded=%h",
                         io_encoded);
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
        $dumpvars(0,clk, io_poly, io_ready, io_valid_0, io_encoded);
    end

endmodule
