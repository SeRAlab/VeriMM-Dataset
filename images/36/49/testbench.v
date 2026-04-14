`timescale 1ns/1ps

module VCO_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] V_ctl;
    reg clk;
    reg reset;
    wire [3:0] frequency_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    VCO dut (
        .V_ctl(V_ctl),
        .clk(clk),
        .reset(reset),
        .frequency_out(frequency_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            V_ctl = 0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            V_ctl = 4'd0;
            @(posedge clk);
            #2;
            $display("Testcase 001: Minimum Voltage (V_ctl=0)");
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            V_ctl = 4'd15;
            @(posedge clk);
            #2;
            $display("Testcase 002: Maximum Voltage (V_ctl=15)");
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            V_ctl = 4'd8;
            @(posedge clk);
            #2;
            $display("Testcase 003: Mid-range Voltage (V_ctl=8)");
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            V_ctl = 4'd3;
            @(posedge clk);
            #2;
            $display("Testcase 004: Low-range Voltage (V_ctl=3)");
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            V_ctl = 4'd12;
            @(posedge clk);
            #2;
            $display("Testcase 005: High-range Voltage (V_ctl=12)");
            #1;

            check_outputs(4'd12);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            V_ctl = 4'd1;
            @(posedge clk);
            #2;
            $display("Testcase 006: Step Voltage (V_ctl=1)");
            #1;

            check_outputs(4'd1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("VCO Testbench");
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
        input [3:0] expected_frequency_out;
        begin
            if (expected_frequency_out === (expected_frequency_out ^ frequency_out ^ expected_frequency_out)) begin
                $display("PASS");
                $display("  Outputs: frequency_out=%h",
                         frequency_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frequency_out=%h",
                         expected_frequency_out);
                $display("  Got:      frequency_out=%h",
                         frequency_out);
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
        $dumpvars(0,V_ctl, clk, reset, frequency_out);
    end

endmodule
