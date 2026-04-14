`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [1:0] data;
    reg [1:0] rdaddress;
    reg [1:0] wraddress;
    reg wren;
    wire [1:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .data(data),
        .rdaddress(rdaddress),
        .wraddress(wraddress),
        .wren(wren),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            wren = 0;
            data = 0;
            rdaddress = 0;
            wraddress = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Basic Write and Read (Addr 0)");


            wren = 1; wraddress = 2'b00; data = 2'b11;
            @(posedge clock); #1;


            wren = 0; rdaddress = 2'b00;
            @(posedge clock); #1;

            #1;


            check_outputs(2'b11);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Basic Write and Read (Addr 2)");


            wren = 1; wraddress = 2'b10; data = 2'b01;
            @(posedge clock); #1;


            wren = 0; rdaddress = 2'b10;
            @(posedge clock); #1;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Verify wren=0 prevents writing");


            wren = 1; wraddress = 2'b01; data = 2'b10;
            @(posedge clock); #1;


            wren = 0; wraddress = 2'b01; data = 2'b00;
            @(posedge clock); #1;


            rdaddress = 2'b01;
            @(posedge clock); #1;

            #1;


            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Simultaneous Read and Write");


            wren = 1; wraddress = 2'b11; data = 2'b11;
            @(posedge clock); #1;


            wren = 1; wraddress = 2'b00; data = 2'b01;
            rdaddress = 2'b11;
            @(posedge clock); #1;


            #1;



            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Sequential Read after Full Fill");


            wren = 1; wraddress = 0; data = 2'b00; @(posedge clock); #1;
            wren = 1; wraddress = 1; data = 2'b01; @(posedge clock); #1;
            wren = 1; wraddress = 2; data = 2'b10; @(posedge clock); #1;
            wren = 1; wraddress = 3; data = 2'b11; @(posedge clock); #1;


            wren = 0; rdaddress = 2'b01;
            @(posedge clock); #1;
            #1;

            check_outputs(2'b01);


            rdaddress = 2'b11;
            @(posedge clock); #1;
            #1;

            check_outputs(2'b11);
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
        input [1:0] expected_q;
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
        $dumpvars(0,clock, data, rdaddress, wraddress, wren, q);
    end

endmodule
