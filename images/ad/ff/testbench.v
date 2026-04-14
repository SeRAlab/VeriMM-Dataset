`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [10:0] address;
    reg clock;
    reg [15:0] data;
    reg wren;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clock(clock),
        .data(data),
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
            address = 0;
            data = 0;
            wren = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;

            address = 11'h000;
            data = 16'hABCD;
            wren = 1;
            @(posedge clock);
            #1;

            wren = 0;
            address = 11'h000;
            @(posedge clock);
            #1;
            $display("Testcase %0d: Write and Read Addr 0", test_num);
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;

            address = 11'd2047;
            data = 16'h55AA;
            wren = 1;
            @(posedge clock);
            #1;

            wren = 0;
            address = 11'd2047;
            @(posedge clock);
            #1;
            $display("Testcase %0d: Boundary Address Check (2047)", test_num);
            #1;

            check_outputs(16'h55AA);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;

            address = 11'h0A5;
            data = 16'h1111;
            wren = 1;
            @(posedge clock);
            #1;

            data = 16'h2222;
            @(posedge clock);
            #1;

            wren = 0;
            @(posedge clock);
            #1;
            $display("Testcase %0d: Overwrite Check", test_num);
            #1;

            check_outputs(16'h2222);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;

            address = 11'h010;
            data = 16'hCAFE;
            wren = 1;
            @(posedge clock);
            #1;

            data = 16'hBEEF;
            wren = 0;
            @(posedge clock);
            #1;

            address = 11'h010;
            @(posedge clock);
            #1;
            $display("Testcase %0d: Write Enable (wren) Low Check", test_num);
            #1;

            check_outputs(16'hCAFE);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;

            address = 11'h001;
            data = 16'hAAAA;
            wren = 1;
            @(posedge clock);
            #1;

            address = 11'h002;
            data = 16'hBBBB;
            wren = 1;
            @(posedge clock);
            #1;

            wren = 0;
            address = 11'h001;
            @(posedge clock);
            #1;
            $display("Testcase %0d: Address Independence Check", test_num);
            #1;

            check_outputs(16'hAAAA);
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
        $dumpvars(0,address, clock, data, wren, q);
    end

endmodule
