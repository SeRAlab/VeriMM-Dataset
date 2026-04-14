`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] address;
    reg clken;
    reg clock;
    reg [11:0] data;
    reg wren;
    wire [11:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clken(clken),
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
        clken = 0;
        data = 0;
        wren = 0;
        @(posedge clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Basic Write and Read", test_num);
        reset_dut();


        address = 8'h05;
        data = 12'hABC;
        wren = 1;
        clken = 1;
        @(posedge clock);
        #1;


        wren = 0;
        @(posedge clock);
        #1;

        #1;


        check_outputs(12'hABC);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: clken inhibits Write", test_num);
        reset_dut();


        address = 8'h10; data = 12'h111; wren = 1; clken = 1;
        @(posedge clock); #1;


        data = 12'h222; clken = 0;
        @(posedge clock); #1;


        wren = 0; clken = 1;
        @(posedge clock); #1;

        #1;


        check_outputs(12'h111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: wren inhibits Write", test_num);
        reset_dut();


        address = 8'h20; data = 12'hAAA; wren = 1; clken = 1;
        @(posedge clock); #1;


        data = 12'hBBB; wren = 0;
        @(posedge clock); #1;


        @(posedge clock); #1;

        #1;


        check_outputs(12'hAAA);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Bank Selection", test_num);
        reset_dut();


        address = 8'h01; data = 12'h123; wren = 1; clken = 1;
        @(posedge clock); #1;


        address = 8'hF1; data = 12'h456;
        @(posedge clock); #1;


        address = 8'h01; wren = 0;
        @(posedge clock); #1;
        if (q !== 12'h123) $display("Error reading Bank 0");


        address = 8'hF1;
        @(posedge clock); #1;

        #1;


        check_outputs(12'h456);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: clken inhibits Output Update", test_num);
        reset_dut();


        address = 8'h30; data = 12'h777; wren = 1; clken = 1;
        @(posedge clock); #1;


        address = 8'h31; data = 12'h888;
        @(posedge clock); #1;


        address = 8'h30; wren = 0;
        @(posedge clock); #1;


        address = 8'h31; clken = 0;
        @(posedge clock); #1;


        #1;



        check_outputs(12'h777);
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
        input [11:0] expected_q;
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
        $dumpvars(0,address, clken, clock, data, wren, q);
    end

endmodule
