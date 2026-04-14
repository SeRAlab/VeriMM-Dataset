`timescale 1ns/1ps

module edge_detector_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg signal_in;
    wire edge_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    edge_detector dut (
        .clk(clk),
        .rst(rst),
        .signal_in(signal_in),
        .edge_out(edge_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        signal_in = 0;
        repeat(2) @(posedge clk);
        #1 rst = 0;
        repeat(1) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Detect rising edge");
        reset_dut();
        @(posedge clk);
        signal_in <= 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Pulse duration (should return to 0)");
        reset_dut();
        @(posedge clk);
        signal_in <= 1;
        @(posedge clk);
        @(posedge clk);
        #2;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Falling edge (1->0) should not trigger");
        reset_dut();
        @(posedge clk);
        signal_in <= 1;
        repeat(2) @(posedge clk);
        signal_in <= 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Constant low signal");
        reset_dut();
        @(posedge clk);
        signal_in <= 0;
        repeat(2) @(posedge clk);
        #2;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Constant high signal (after initial edge)");
        reset_dut();
        @(posedge clk);
        signal_in <= 1;
        repeat(3) @(posedge clk);
        #2;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Second rising edge detection");
        reset_dut();

        @(posedge clk);
        signal_in <= 1;
        repeat(2) @(posedge clk);

        signal_in <= 0;
        @(posedge clk);

        signal_in <= 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("edge_detector Testbench");
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
        input expected_edge_out;
        begin
            if (expected_edge_out === (expected_edge_out ^ edge_out ^ expected_edge_out)) begin
                $display("PASS");
                $display("  Outputs: edge_out=%b",
                         edge_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: edge_out=%b",
                         expected_edge_out);
                $display("  Got:      edge_out=%b",
                         edge_out);
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
        $dumpvars(0,clk, rst, signal_in, edge_out);
    end

endmodule
