`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr;
    reg clock;
    reg [7:0] data;
    reg we;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clock(clock),
        .data(data),
        .we(we),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        addr = 0;
        data = 0;
        we = 0;
        @(posedge clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test %03d: Basic Write and Read", test_num);
        reset_dut();


        addr = 8'h10; data = 8'hAA; we = 1;
        @(posedge clock);


        #1; we = 0; addr = 8'h10;
        @(posedge clock);
        #2;

        #1;


        check_outputs(8'hAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %03d: Write Enable (we) Check", test_num);
        reset_dut();


        addr = 8'h20; data = 8'h55; we = 1;
        @(posedge clock);


        #1; addr = 8'h20; data = 8'hEE; we = 0;
        @(posedge clock);


        #1; addr = 8'h20;
        @(posedge clock);
        #2;

        #1;


        check_outputs(8'h55);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %03d: Overwriting Memory", test_num);
        reset_dut();

        addr = 8'h05; data = 8'h11; we = 1;
        @(posedge clock);
        #1; data = 8'h22;
        @(posedge clock);

        #1; we = 0; addr = 8'h05;
        @(posedge clock);
        #2;

        #1;


        check_outputs(8'h22);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %03d: Simultaneous Read and Write Check", test_num);
        reset_dut();


        addr = 8'h30; data = 8'hCC; we = 1;
        @(posedge clock);


        #2;
        #1;

        check_outputs(8'hCC);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %03d: Address Independence", test_num);
        reset_dut();


        addr = 8'h01; data = 8'h01; we = 1;
        @(posedge clock);


        #1; addr = 8'h02; data = 8'h02;
        @(posedge clock);


        #1; we = 0; addr = 8'h01;
        @(posedge clock);
        #2;

        #1;


        check_outputs(8'h01);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %03d: Boundary Address (0xFF)", test_num);
        reset_dut();

        addr = 8'hFF; data = 8'h99; we = 1;
        @(posedge clock);

        #1; we = 0;
        @(posedge clock);
        #2;

        #1;


        check_outputs(8'h99);
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
        input [7:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,addr, clock, data, we, out);
    end

endmodule
