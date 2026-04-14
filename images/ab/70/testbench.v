`timescale 1ns/1ps

module t_flip_flop_sync_reset_tb;

    // Testbench signals (sequential circuit)
    reg T;
    reg clk;
    reg rst_n;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    t_flip_flop_sync_reset dut (
        .T(T),
        .clk(clk),
        .rst_n(rst_n),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        T = 0;
        rst_n = 0;
        @(posedge clk);
        #1;
        rst_n = 1;
        test_num = test_num + 1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        $display("Testcase 001: Verify Reset State");

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        $display("Testcase 002: Single Toggle (0 -> 1)");
        T = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        $display("Testcase 003: Double Toggle (0 -> 1 -> 0)");
        T = 1;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        $display("Testcase 004: Hold State when T=0");
        T = 0;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        $display("Testcase 005: Hold State when T=0 after Toggling");

        T = 1;
        @(posedge clk);
        #1;

        T = 0;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        $display("Testcase 006: Synchronous Reset Priority over Toggle");

        T = 1;
        @(posedge clk);
        #1;

        rst_n = 0;
        T = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        $display("Testcase 007: Multiple Toggles (4 cycles)");
        T = 1;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("t_flip_flop_sync_reset Testbench");
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
        input expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%b",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b",
                         expected_Q);
                $display("  Got:      Q=%b",
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
        $dumpvars(0,T, clk, rst_n, Q);
    end

endmodule
