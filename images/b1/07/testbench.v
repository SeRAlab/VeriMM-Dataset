`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] address_a;
    reg [5:0] address_b;
    reg clock;
    reg [15:0] data_a;
    reg [15:0] data_b;
    reg wren_a;
    reg wren_b;
    wire [15:0] q_a;
    wire [15:0] q_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address_a(address_a),
        .address_b(address_b),
        .clock(clock),
        .data_a(data_a),
        .data_b(data_b),
        .wren_a(wren_a),
        .wren_b(wren_b),
        .q_a(q_a),
        .q_b(q_b)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            address_a = 0;
            address_b = 0;
            data_a = 0;
            data_b = 0;
            wren_a = 0;
            wren_b = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Port A Write/Read...");
            reset_dut();

            address_a = 6'd10;
            data_a = 16'hA5A5;
            wren_a = 1;
            @(posedge clock);
            #1;

            wren_a = 0;
            address_a = 6'd10;
            @(posedge clock);
            #1;
            #1;

            check_outputs(16'hA5A5, 16'hXXXX);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Basic Port B Write/Read...");
            reset_dut();

            address_b = 6'd50;
            data_b = 16'h5A5A;
            wren_b = 1;
            @(posedge clock);
            #1;

            wren_b = 0;
            address_b = 6'd50;
            @(posedge clock);
            #1;
            #1;

            check_outputs(16'hXXXX, 16'h5A5A);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Simultaneous Writes...");
            reset_dut();

            address_a = 6'd5;  data_a = 16'h1111; wren_a = 1;
            address_b = 6'd60; data_b = 16'h2222; wren_b = 1;
            @(posedge clock);
            #1;
            wren_a = 0; wren_b = 0;
            address_a = 6'd5;
            address_b = 6'd60;
            @(posedge clock);
            #1;
            #1;

            check_outputs(16'h1111, 16'h2222);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Cross Port Access...");
            reset_dut();

            address_a = 6'd32; data_a = 16'hCAFE; wren_a = 1;
            @(posedge clock);
            #1;

            wren_a = 0;
            address_b = 6'd32;
            @(posedge clock);
            #1;
            #1;

            check_outputs(16'hXXXX, 16'hCAFE);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Wren logic verification...");
            reset_dut();

            address_a = 6'd15; data_a = 16'h7777; wren_a = 1;
            @(posedge clock);
            #1;

            data_a = 16'hEEEE; wren_a = 0;
            @(posedge clock);
            #1;

            address_a = 6'd15;
            @(posedge clock);
            #1;
            #1;

            check_outputs(16'h7777, 16'hXXXX);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Simultaneous reads from same address...");
            reset_dut();

            address_a = 6'd21; data_a = 16'hB0BA; wren_a = 1;
            @(posedge clock);
            #1;

            wren_a = 0;
            address_a = 6'd21;
            address_b = 6'd21;
            @(posedge clock);
            #1;
            #1;

            check_outputs(16'hB0BA, 16'hB0BA);
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
        input [15:0] expected_q_a;
        input [15:0] expected_q_b;
        begin
            if (expected_q_a === (expected_q_a ^ q_a ^ expected_q_a) &&
                expected_q_b === (expected_q_b ^ q_b ^ expected_q_b)) begin
                $display("PASS");
                $display("  Outputs: q_a=%h, q_b=%h",
                         q_a, q_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q_a=%h, q_b=%h",
                         expected_q_a, expected_q_b);
                $display("  Got:      q_a=%h, q_b=%h",
                         q_a, q_b);
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
        $dumpvars(0,address_a, address_b, clock, data_a, data_b, wren_a, wren_b, q_a, q_b);
    end

endmodule
