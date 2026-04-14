`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [8:0] address_a;
    reg [8:0] address_b;
    reg clock;
    wire [31:0] q_a;
    wire [31:0] q_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address_a(address_a),
        .address_b(address_b),
        .clock(clock),
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
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            address_a = 9'd0;
            address_b = 9'd1;
            @(posedge clock);
            #2;
            $display("Testcase %03d: Addr 0 (Even), Addr 1 (Odd)", test_num);
            #1;

            check_outputs(32'd0, 32'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            address_a = 9'd2;
            address_b = 9'd3;
            @(posedge clock);
            #2;
            $display("Testcase %03d: Addr 2 (Even), Addr 3 (Odd)", test_num);
            #1;

            check_outputs(32'd8, 32'd9);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            address_a = 9'd4;
            address_b = 9'd5;
            @(posedge clock);
            #2;
            $display("Testcase %03d: Addr 4 (Even), Addr 5 (Odd)", test_num);
            #1;

            check_outputs(32'd64, 32'd25);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            address_a = 9'd10;
            address_b = 9'd7;
            @(posedge clock);
            #2;
            $display("Testcase %03d: Addr 10 (Even), Addr 7 (Odd)", test_num);
            #1;

            check_outputs(32'd1000, 32'd49);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            address_a = 9'd63;
            address_b = 9'd62;
            @(posedge clock);
            #2;
            $display("Testcase %03d: Addr 63 (Odd), Addr 62 (Even)", test_num);
            #1;

            check_outputs(32'd3969, 32'd238328);
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
        input [31:0] expected_q_a;
        input [31:0] expected_q_b;
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
        $dumpvars(0,address_a, address_b, clock, q_a, q_b);
    end

endmodule
