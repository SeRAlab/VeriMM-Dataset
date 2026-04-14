`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clock;
    reg Enable;
    reg [3:0] I;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clock(Clock),
        .Enable(Enable),
        .I(I),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end

        task reset_dut;

    begin
        @(negedge Clock);
        Enable = 1;
        I = 4'h0;
        @(posedge Clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Basic write (Enable=1, I=4'hA)", test_num);
        reset_dut();
        @(negedge Clock);
        Enable = 1;
        I = 4'hA;
        @(posedge Clock);
        #1;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Hold value (Enable=0, I changes)", test_num);
        reset_dut();

        @(negedge Clock);
        Enable = 1;
        I = 4'h5;
        @(posedge Clock);
        #1;

        @(negedge Clock);
        Enable = 0;
        I = 4'hF;
        @(posedge Clock);
        #1;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: All ones (Enable=1, I=4'hF)", test_num);
        reset_dut();
        @(negedge Clock);
        Enable = 1;
        I = 4'hF;
        @(posedge Clock);
        #1;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Successive writes", test_num);
        reset_dut();
        @(negedge Clock);
        Enable = 1;
        I = 4'h3;
        @(posedge Clock);
        @(negedge Clock);
        I = 4'hC;
        @(posedge Clock);
        #1;
        #1;

        check_outputs(4'hC);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Intermittent Enable behavior", test_num);
        reset_dut();

        @(negedge Clock);
        Enable = 1;
        I = 4'h7;
        @(posedge Clock);

        @(negedge Clock);
        Enable = 0;
        I = 4'h2;
        @(posedge Clock);

        @(negedge Clock);
        Enable = 1;
        @(posedge Clock);
        #1;
        #1;

        check_outputs(4'h2);
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
        input [3:0] expected_Q;
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
        $dumpvars(0,Clock, Enable, I, Q);
    end

endmodule
