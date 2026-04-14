`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [12:0] add;
    reg clk;
    reg we;
    reg [15:0] wr;
    wire [15:0] rd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .add(add),
        .clk(clk),
        .we(we),
        .wr(wr),
        .rd(rd)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            add = 0;
            wr = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write and Read at address 0");
            reset_dut();

            @(posedge clk);
            we <= 1;
            add <= 13'h0000;
            wr <= 16'hA5A5;
            @(posedge clk);

            we <= 0;
            add <= 13'h0000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Basic Write and Read at max address (8191)");
            reset_dut();

            @(posedge clk);
            we <= 1;
            add <= 13'd8191;
            wr <= 16'h5A5A;
            @(posedge clk);

            we <= 0;
            add <= 13'd8191;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h5A5A);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Verify Write Enable (WE=0 should not write)");
            reset_dut();

            @(posedge clk);
            we <= 1; add <= 13'h0100; wr <= 16'h1111;
            @(posedge clk);

            we <= 0; add <= 13'h0100; wr <= 16'hEEEE;
            @(posedge clk);

            we <= 0; add <= 13'h0100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h1111);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Overwriting data");
            reset_dut();

            @(posedge clk);
            we <= 1; add <= 13'h0ABC; wr <= 16'h1234;
            @(posedge clk);

            we <= 1; add <= 13'h0ABC; wr <= 16'h9876;
            @(posedge clk);

            we <= 0; add <= 13'h0ABC;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h9876);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Write multiple, read specific");
            reset_dut();

            @(posedge clk);
            we <= 1; add <= 13'd10; wr <= 16'hAAAA;
            @(posedge clk);

            we <= 1; add <= 13'd20; wr <= 16'hBBBB;
            @(posedge clk);

            we <= 0; add <= 13'd10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hAAAA);
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
        input [15:0] expected_rd;
        begin
            if (expected_rd === (expected_rd ^ rd ^ expected_rd)) begin
                $display("PASS");
                $display("  Outputs: rd=%h",
                         rd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd=%h",
                         expected_rd);
                $display("  Got:      rd=%h",
                         rd);
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
        $dumpvars(0,add, clk, we, wr, rd);
    end

endmodule
