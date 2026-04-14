`timescale 1ns/1ps

module ring_counter_12bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    wire [11:0] ring_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ring_counter_12bit dut (
        .clk(clk),
        .rst_n(rst_n),
        .ring_out(ring_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        @(posedge clk);
        #1;
        rst_n = 1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Checking reset state (Should be 001h)", test_num);
        reset_dut();

        #1;


        check_outputs(12'h001);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Checking 1 clock cycle shift (Should be 002h)", test_num);
        reset_dut();
        @(posedge clk);
        #1;
        #1;

        check_outputs(12'h002);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Checking 6 clock cycles shift (Should be 040h)", test_num);
        reset_dut();
        repeat(6) @(posedge clk);
        #1;
        #1;

        check_outputs(12'h040);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Checking 11 clock cycles shift (Should be 800h)", test_num);
        reset_dut();
        repeat(11) @(posedge clk);
        #1;
        #1;

        check_outputs(12'h800);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Checking full rotation wrap-around (Should be 001h)", test_num);
        reset_dut();
        repeat(12) @(posedge clk);
        #1;
        #1;

        check_outputs(12'h001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Checking 25 clock cycles (Should be 002h)", test_num);
        reset_dut();
        repeat(25) @(posedge clk);
        #1;
        #1;

        check_outputs(12'h002);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ring_counter_12bit Testbench");
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
        input [11:0] expected_ring_out;
        begin
            if (expected_ring_out === (expected_ring_out ^ ring_out ^ expected_ring_out)) begin
                $display("PASS");
                $display("  Outputs: ring_out=%h",
                         ring_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ring_out=%h",
                         expected_ring_out);
                $display("  Got:      ring_out=%h",
                         ring_out);
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
        $dumpvars(0,clk, rst_n, ring_out);
    end

endmodule
