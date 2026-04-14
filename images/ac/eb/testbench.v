`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] byteena_a;
    reg clock;
    reg [15:0] data;
    reg [8:0] rdaddress;
    reg [8:0] wraddress;
    reg wren;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .byteena_a(byteena_a),
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
            byteena_a = 2'b0;
            data = 16'b0;
            rdaddress = 9'b0;
            wraddress = 9'b0;
            wren = 1'b0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            @(negedge clock);
            wraddress = 9'h010;
            data = 16'hABCD;
            byteena_a = 2'b11;
            wren = 1'b1;

            @(negedge clock);
            wren = 1'b0;


            rdaddress = 9'h010;


            @(posedge clock);
            #2;

            $display("Testcase 001: Full Word Write/Read");
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            @(negedge clock);
            wraddress = 9'h020;
            data = 16'h0000;
            byteena_a = 2'b11;
            wren = 1'b1;


            @(negedge clock);
            data = 16'hAA55;
            byteena_a = 2'b01;

            @(negedge clock);
            wren = 1'b0;
            rdaddress = 9'h020;

            @(posedge clock);
            #2;

            $display("Testcase 002: Lower Byte Enable");

            #1;


            check_outputs(16'h0055);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            @(negedge clock);
            wraddress = 9'h030;
            data = 16'hFFFF;
            byteena_a = 2'b11;
            wren = 1'b1;


            @(negedge clock);
            data = 16'hBB22;
            byteena_a = 2'b10;

            @(negedge clock);
            wren = 1'b0;
            rdaddress = 9'h030;

            @(posedge clock);
            #2;

            $display("Testcase 003: Upper Byte Enable");

            #1;


            check_outputs(16'hBBFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            @(negedge clock);
            wraddress = 9'h040;
            data = 16'h1234;
            byteena_a = 2'b11;
            wren = 1'b1;


            @(negedge clock);
            data = 16'h5678;
            wren = 1'b0;

            @(negedge clock);
            rdaddress = 9'h040;

            @(posedge clock);
            #2;

            $display("Testcase 004: Write Enable (wren) Logic");

            #1;


            check_outputs(16'h1234);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            @(negedge clock);
            wraddress = 9'h050;
            data = 16'h7777;
            byteena_a = 2'b11;
            wren = 1'b1;

            @(negedge clock);

            wraddress = 9'h060;
            data = 16'h8888;
            rdaddress = 9'h050;

            @(posedge clock);
            #2;

            $display("Testcase 005: Parallel Read/Write");
            #1;

            check_outputs(16'h7777);
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
        input [15:0] expected_q;
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
        $dumpvars(0,byteena_a, clock, data, rdaddress, wraddress, wren, q);
    end

endmodule
