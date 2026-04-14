`timescale 1ns/1ps

module clock_gating_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg enable;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    clock_gating dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        enable = 0;
        data_in = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Running Testcase 001: Basic Data Transfer (Enabled)");
        enable = 1;
        data_in = 4'hA;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Running Testcase 002: Clock Gating Functionality (Disabled)");


        enable = 1;
        data_in = 4'h5;
        @(posedge clk);
        #1;


        enable = 0;
        data_in = 4'hF;
        @(posedge clk);
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Running Testcase 003: Recovery from Gated State");

        enable = 0;
        data_in = 4'h3;
        @(posedge clk);
        #1;

        enable = 1;
        data_in = 4'hC;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'hC);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Running Testcase 004: Multiple Data Changes while Gated");

        enable = 1;
        data_in = 4'h7;
        @(posedge clk);
        #1;

        enable = 0;
        data_in = 4'h1; @(posedge clk);
        data_in = 4'h2; @(posedge clk);
        data_in = 4'h3; @(posedge clk);
        #2;
        #1;

        check_outputs(4'h7);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Running Testcase 005: Zero Data Check");

        enable = 1;
        data_in = 4'hF;
        @(posedge clk);
        #1;
        data_in = 4'h0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'h0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("clock_gating Testbench");
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
        input [3:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, enable, data_out);
    end

endmodule
