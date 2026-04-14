`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] address;
    reg clock;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clock(clock),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            address = 8'h0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Reading Address 0x00");
            address = 8'h00;
            @(posedge clock);
            #2;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Reading Address 0x01");
            address = 8'h01;
            @(posedge clock);
            #2;

            #1;


            check_outputs(32'h00000001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Reading Address 0x7F");
            address = 8'h7F;
            @(posedge clock);
            #2;

            #1;


            check_outputs(32'h0000007F);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Reading Address 0xFF");
            address = 8'hFF;
            @(posedge clock);
            #2;

            #1;


            check_outputs(32'h000000FF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Sequential Access 0x0A then 0x0B");

            address = 8'h0A;
            @(posedge clock);
            #1;

            address = 8'h0B;
            @(posedge clock);
            #2;

            #1;


            check_outputs(32'h0000000B);
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
        input [31:0] expected_q;
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
        $dumpvars(0,address, clock, q);
    end

endmodule
