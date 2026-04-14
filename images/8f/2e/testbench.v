`timescale 1ns/1ps

module edge_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    reg signal_in;
    wire [7:0] edge_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    edge_counter dut (
        .clk(clk),
        .rst_n(rst_n),
        .signal_in(signal_in),
        .edge_count(edge_count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        signal_in = 0;
        repeat(2) @(posedge clk);
        #1 rst_n = 1;
        repeat(1) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Reset condition");
        reset_dut();
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Single rising edge");
        reset_dut();
        @(posedge clk);
        #1 signal_in = 1;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase003;

    integer i;
    begin
        test_num = 3;
        $display("Testcase 003: Multiple pulses (5)");
        reset_dut();
        for (i = 0; i < 5; i = i + 1) begin
            @(posedge clk);
            #1 signal_in = 1;
            @(posedge clk);
            #1 signal_in = 0;
        end
        repeat(2) @(posedge clk);
        #1;

        check_outputs(8'd5);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Signal held high");
        reset_dut();
        @(posedge clk);
        #1 signal_in = 1;
        repeat(10) @(posedge clk);
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Signal held low");
        reset_dut();
        signal_in = 0;
        repeat(10) @(posedge clk);
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Reset during operation");
        reset_dut();

        repeat(3) begin
            @(posedge clk); #1 signal_in = 1;
            @(posedge clk); #1 signal_in = 0;
        end

        repeat(1) @(posedge clk);


        rst_n = 0;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(8'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("edge_counter Testbench");
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
        input [7:0] expected_edge_count;
        begin
            if (expected_edge_count === (expected_edge_count ^ edge_count ^ expected_edge_count)) begin
                $display("PASS");
                $display("  Outputs: edge_count=%h",
                         edge_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: edge_count=%h",
                         expected_edge_count);
                $display("  Got:      edge_count=%h",
                         edge_count);
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
        $dumpvars(0,clk, rst_n, signal_in, edge_count);
    end

endmodule
