`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [8:0] address_a;
    reg [8:0] address_b;
    reg clock;
    wire [3:0] q_a;
    wire [3:0] q_b;

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
            address_a = 9'd0;
            address_b = 9'd0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: MSB both 0", test_num);
            reset_dut();

            address_a = 9'h003;
            address_b = 9'h007;

            @(posedge clock);
            #2;
            #1;

            check_outputs(4'h5, 4'h9);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: MSB both 1", test_num);
            reset_dut();

            address_a = 9'h103;
            address_b = 9'h107;

            @(posedge clock);
            #2;
            #1;

            check_outputs(4'h4, 4'h8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Mixed MSB (a=0, b=1)", test_num);
            reset_dut();

            address_a = 9'h001;
            address_b = 9'h101;

            @(posedge clock);
            #2;
            #1;

            check_outputs(4'h3, 4'h2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Mixed MSB (a=1, b=0)", test_num);
            reset_dut();

            address_a = 9'h10A;
            address_b = 9'h00A;

            @(posedge clock);
            #2;
            #1;

            check_outputs(4'hB, 4'hC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Overflow check (lower bits = 15)", test_num);
            reset_dut();

            address_a = 9'h00F;
            address_b = 9'h10F;

            @(posedge clock);
            #2;
            #1;

            check_outputs(4'h1, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Overflow check (lower bits = 14)", test_num);
            reset_dut();

            address_a = 9'h00E;
            address_b = 9'h10E;

            @(posedge clock);
            #2;
            #1;

            check_outputs(4'h0, 4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Zero value check", test_num);
            reset_dut();

            address_a = 9'h000;
            address_b = 9'h100;

            @(posedge clock);
            #2;
            #1;

            check_outputs(4'h2, 4'h1);
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
        input [3:0] expected_q_a;
        input [3:0] expected_q_b;
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
