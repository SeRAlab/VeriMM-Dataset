`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] D;
    reg clock;
    reg enable;
    wire [31:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .clock(clock),
        .enable(enable),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            enable = 1;
            D = 32'h0;
            repeat (DEPTH + 1) @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Basic Shift", test_num);
            reset_dut();

            @(posedge clock);
            D = 32'hABCDE001;
            enable = 1;

            repeat (DEPTH) @(posedge clock);
            #1;
            #1;

            check_outputs(32'hABCDE001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Enable Signal Logic", test_num);
            reset_dut();

            @(posedge clock);
            D = 32'h5555AAAA;
            enable = 1;

            @(posedge clock);
            D = 32'hFFFFFFFF;
            enable = 0;

            repeat (DEPTH + 2) @(posedge clock);
            #1;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        reg [31:0] val1, val2, val3, val4;
        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Sequential Stream", test_num);
            reset_dut();

            val1 = 32'h11111111;
            val2 = 32'h22222222;
            val3 = 32'h33333333;
            val4 = 32'h44444444;

            @(posedge clock); D = val1; enable = 1;
            @(posedge clock); D = val2;
            @(posedge clock); D = val3;
            @(posedge clock); D = val4;
            @(posedge clock); D = 32'h0;

            #1;
            #1;

            check_outputs(val1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Full Depth Propagation", test_num);
            reset_dut();

            @(posedge clock);
            D = 32'hDEADBEEF;
            enable = 1;

            repeat (DEPTH) @(posedge clock);
            #1;
            #1;

            check_outputs(32'hDEADBEEF);
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
        input [31:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,D, clock, enable, Q);
    end

endmodule
