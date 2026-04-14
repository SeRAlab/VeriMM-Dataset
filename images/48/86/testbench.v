`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] address_a;
    reg [3:0] address_b;
    reg clock;
    reg [15:0] data_a;
    reg [15:0] data_b;
    reg write_enable_a;
    reg write_enable_b;
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
        .write_enable_a(write_enable_a),
        .write_enable_b(write_enable_b),
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
            write_enable_a = 0;
            write_enable_b = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Port A Basic Write/Read");
            reset_dut();
            address_a = 4'h1;
            data_a = 16'hAAAA;
            write_enable_a = 1;
            @(posedge clock);
            #1;
            write_enable_a = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(16'hAAAA, 16'hxxxx);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Port B Basic Write/Read");
            reset_dut();
            address_b = 4'h2;
            data_b = 16'hBBBB;
            write_enable_b = 1;
            @(posedge clock);
            #1;
            write_enable_b = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(16'hxxxx, 16'hBBBB);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Simultaneous Port A and Port B Write/Read");
            reset_dut();
            address_a = 4'h5;
            address_b = 4'h5;
            data_a = 16'h1234;
            data_b = 16'h5678;
            write_enable_a = 1;
            write_enable_b = 1;
            @(posedge clock);
            #1;
            write_enable_a = 0;
            write_enable_b = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(16'h1234, 16'h5678);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Port A Write Enable Check");
            reset_dut();

            address_a = 4'hA;
            data_a = 16'hFFFF;
            write_enable_a = 1;
            @(posedge clock);
            #1;

            data_a = 16'h0000;
            write_enable_a = 0;
            @(posedge clock);
            #1;

            @(posedge clock);
            #1;
            #1;

            check_outputs(16'hFFFF, 16'hxxxx);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Boundary Address (15) Check");
            reset_dut();
            address_a = 4'hF;
            address_b = 4'hF;
            data_a = 16'hC0DE;
            data_b = 16'hBEEF;
            write_enable_a = 1;
            write_enable_b = 1;
            @(posedge clock);
            #1;
            write_enable_a = 0;
            write_enable_b = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(16'hC0DE, 16'hBEEF);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Data Pattern Check");
            reset_dut();
            address_a = 4'h0;
            address_b = 4'h1;
            data_a = 16'h5555;
            data_b = 16'hAAAA;
            write_enable_a = 1;
            write_enable_b = 1;
            @(posedge clock);
            #1;
            write_enable_a = 0;
            write_enable_b = 0;
            address_a = 4'h0;
            address_b = 4'h1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(16'h5555, 16'hAAAA);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Overwrite Port B");
            reset_dut();
            address_b = 4'h7;
            data_b = 16'h1111;
            write_enable_b = 1;
            @(posedge clock);
            #1;
            data_b = 16'h2222;
            @(posedge clock);
            #1;
            write_enable_b = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(16'hxxxx, 16'h2222);
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
        testcase007();
        
        
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
        $dumpvars(0,address_a, address_b, clock, data_a, data_b, write_enable_a, write_enable_b, q_a, q_b);
    end

endmodule
