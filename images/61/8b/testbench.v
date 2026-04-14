`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg [3:0] data;
    reg ena;
    reg load;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clr(clr),
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
        clr <= 1;
        load <= 0;
        ena <= 0;
        data <= 0;
        @(posedge clk);
        #1;
        clr <= 0;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Load then Synchronous Clear");
        reset_dut();
        load <= 1; data <= 4'hA;
        @(posedge clk);
        #1;
        load <= 0; clr <= 1;
        @(posedge clk);
        #1;
        clr <= 0;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Load 4'h5 into register");
        reset_dut();
        load <= 1; data <= 4'h5;
        @(posedge clk);
        #1;
        load <= 0;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Shift Left 4'h1 -> 4'h2");
        reset_dut();
        load <= 1; data <= 4'h1;
        @(posedge clk);
        #1;
        load <= 0; ena <= 1;
        @(posedge clk);
        #1;
        ena <= 0;
        #1;

        check_outputs(4'h2);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Triple Shift Left 4'h1 -> 4'h8");
        reset_dut();
        load <= 1; data <= 4'h1;
        @(posedge clk);
        #1;
        load <= 0; ena <= 1;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #1;
        ena <= 0;
        #1;

        check_outputs(4'h8);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Shift Left 4'h8 -> 4'h0");
        reset_dut();
        load <= 1; data <= 4'h8;
        @(posedge clk);
        #1;
        load <= 0; ena <= 1;
        @(posedge clk);
        #1;
        ena <= 0;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Priority - clr over load");
        reset_dut();
        clr <= 1; load <= 1; data <= 4'hF;
        @(posedge clk);
        #1;
        clr <= 0; load <= 0;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Priority - load over ena");
        reset_dut();
        load <= 1; data <= 4'h7;
        @(posedge clk);
        #1;
        load <= 1; ena <= 1; data <= 4'hE;
        @(posedge clk);
        #1;
        load <= 0; ena <= 0;
        #1;

        check_outputs(4'hE);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Register holds value when load=0, ena=0");
        reset_dut();
        load <= 1; data <= 4'hB;
        @(posedge clk);
        #1;
        load <= 0; ena <= 0;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'hB);
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
        testcase008();
        
        
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
        input [3:0] expected_q;
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
        $dumpvars(0,clk, clr, data, ena, load, q);
    end

endmodule
