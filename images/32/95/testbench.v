`timescale 1ns/1ps

module fractional_n_pll_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] F;
    reg [9:0] N;
    reg clk;
    reg reset;
    wire clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fractional_n_pll dut (
        .F(F),
        .N(N),
        .clk(clk),
        .reset(reset),
        .clk_out(clk_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        F = 0;
        N = 0;
        #20;
        reset = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        N = 10'd4;
        F = 10'd0;


        #60;
        $display("Testcase 001: Integer N=4, F=0");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        N = 10'd10;
        F = 10'd0;

        #120;
        $display("Testcase 002: Integer N=10, F=0");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        N = 10'd2;
        F = 10'd512;


        #45;
        $display("Testcase 003: Fractional N=2, F=512");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        N = 10'd2;
        F = 10'd0;
        #20;
        $display("Testcase 004: Minimum N=2, F=0");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        N = 10'd100;
        F = 10'd1023;
        #1050;
        $display("Testcase 005: Large N=100, F=1023");
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
        $display("fractional_n_pll Testbench");
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
        input expected_clk_out;
        begin
            if (expected_clk_out === (expected_clk_out ^ clk_out ^ expected_clk_out)) begin
                $display("PASS");
                $display("  Outputs: clk_out=%b",
                         clk_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out=%b",
                         expected_clk_out);
                $display("  Got:      clk_out=%b",
                         clk_out);
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
        $dumpvars(0,F, N, clk, reset, clk_out);
    end

endmodule
