`timescale 1ns/1ps

module clock_gating_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg enable;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    clock_gating dut (
        .clk(clk),
        .d(d),
        .enable(enable),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        enable = 1;
        d = 0;
        @(posedge clk);
        #1;
        enable = 0;
        d = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Normal Write (Enable=1, D=1)");
        reset_dut();
        test_num = test_num + 1;
        enable = 1;
        d = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Clock Gating (Enable=0, D changes)");
        reset_dut();
        test_num = test_num + 1;

        enable = 1;
        d = 1;
        @(posedge clk);
        #1;

        enable = 0;
        d = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Gated from start (Enable=0, D=1)");
        reset_dut();
        test_num = test_num + 1;
        enable = 0;
        d = 1;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Enable/Disable/Enable toggle sequence");
        reset_dut();
        test_num = test_num + 1;

        enable = 1; d = 1;
        @(posedge clk); #1;

        enable = 0; d = 0;
        @(posedge clk); #1;

        enable = 1; d = 0;
        @(posedge clk); #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Multiple cycles with Enable=1");
        reset_dut();
        test_num = test_num + 1;
        enable = 1;
        d = 1; @(posedge clk); #1;
        d = 0; @(posedge clk); #1;
        d = 1; @(posedge clk); #1;
        #1;

        check_outputs(1'b1);
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
        input expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%b",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b",
                         expected_q);
                $display("  Got:      q=%b",
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
        $dumpvars(0,clk, d, enable, q);
    end

endmodule
