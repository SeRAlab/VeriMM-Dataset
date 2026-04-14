`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg fclk;
    reg int_start;
    reg iorq_n;
    reg m1_n;
    reg wait_n;
    reg zneg;
    reg zpos;
    wire int_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .fclk(fclk),
        .int_start(int_start),
        .iorq_n(iorq_n),
        .m1_n(m1_n),
        .wait_n(wait_n),
        .zneg(zneg),
        .zpos(zpos),
        .int_n(int_n)
    );

    // Clock generation (10ns period)
    initial begin
        fclk = 0;
        forever #5 fclk = ~fclk;
    end

        task reset_dut;

    begin
        int_start = 0;
        iorq_n = 1;
        m1_n = 1;
        wait_n = 1;
        zneg = 0;
        zpos = 0;
        repeat(2) @(posedge fclk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        int_start = 1;
        @(posedge fclk);
        #1;
        int_start = 0;
        @(posedge fclk);
        #1;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();

        int_start = 1;
        @(posedge fclk);
        #1;
        int_start = 0;


        iorq_n = 0;
        m1_n = 0;
        zneg = 1;
        @(posedge fclk);
        #1;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        int_start = 1;
        @(posedge fclk);
        #1;
        int_start = 0;

        iorq_n = 0;
        m1_n = 1;
        zneg = 1;
        @(posedge fclk);
        #1;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        int_start = 1;
        @(posedge fclk);
        #1;
        int_start = 0;

        iorq_n = 1;
        m1_n = 0;
        zneg = 1;
        @(posedge fclk);
        #1;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        int_start = 1;
        @(posedge fclk);
        #1;
        int_start = 0;


        repeat(20) begin
            @(posedge fclk);
            zpos = ~zpos;
            wait_n = ~wait_n;
        end
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
        input expected_int_n;
        begin
            if (expected_int_n === (expected_int_n ^ int_n ^ expected_int_n)) begin
                $display("PASS");
                $display("  Outputs: int_n=%b",
                         int_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: int_n=%b",
                         expected_int_n);
                $display("  Got:      int_n=%b",
                         int_n);
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
        $dumpvars(0,fclk, int_start, iorq_n, m1_n, wait_n, zneg, zpos, int_n);
    end

endmodule
