`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [99:0] data;
    reg [1:0] ena;
    reg load;
    wire [99:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .ena(ena),
        .load(load),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(posedge clk);
        load <= 1;
        data <= 100'b0;
        ena <= 2'b00;
        @(posedge clk);
        load <= 0;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase 001: Parallel Load");
        load <= 1;
        data <= 100'hFEDCBA9876543210FEDCBA9876543210;
        @(posedge clk);
        load <= 0;
        #1;

        check_outputs(100'hFEDCBA9876543210FEDCBA9876543210);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase 002: Left Rotation (1 step)");
        load <= 1;
        data <= 100'h1;
        @(posedge clk);
        load <= 0;
        ena <= 2'b10;
        @(posedge clk);
        ena <= 2'b00;
        #1;

        check_outputs(100'h2);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase 003: Right Rotation (1 step)");
        load <= 1;
        data <= 100'h2;
        @(posedge clk);
        load <= 0;
        ena <= 2'b01;
        @(posedge clk);
        ena <= 2'b00;
        #1;

        check_outputs(100'h1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase 004: Left Rotation Wrap (99 -> 0)");
        load <= 1;
        data <= (100'b1 << 99);
        @(posedge clk);
        load <= 0;
        ena <= 2'b10;
        @(posedge clk);
        ena <= 2'b00;
        #1;

        check_outputs(100'h1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase 005: Right Rotation Wrap (0 -> 99)");
        load <= 1;
        data <= 100'h1;
        @(posedge clk);
        load <= 0;
        ena <= 2'b01;
        @(posedge clk);
        ena <= 2'b00;
        #1;

        check_outputs(100'b1 << 99);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Testcase 006: Load priority over Enable");
        load <= 1;
        data <= 100'hABC;
        ena <= 2'b11;
        @(posedge clk);
        load <= 0;
        ena <= 2'b00;
        #1;

        check_outputs(100'hABC);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        $display("Testcase 007: Verify ena=00 holds value");
        load <= 1;
        data <= 100'h5555555555555555555555555;
        @(posedge clk);
        load <= 0;
        ena <= 2'b00;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(100'h5555555555555555555555555);
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
        input [99:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
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
        $dumpvars(0,clk, data, ena, load, q);
    end

endmodule
