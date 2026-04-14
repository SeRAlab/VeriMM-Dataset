`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data;
    reg rdaddress;
    reg wraddress;
    reg wren;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .rdaddress(rdaddress),
        .wraddress(wraddress),
        .wren(wren),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wren = 0;
            wraddress = 0;
            rdaddress = 0;
            data = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write and Read back...");
            reset_dut();

            wraddress = 4'h4;
            data = 8'hA5;
            wren = 1;
            @(posedge clk);
            #1;
            wren = 0;

            rdaddress = 4'h4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Write to different address...");
            reset_dut();

            wraddress = 4'hF;
            data = 8'h5A;
            wren = 1;
            @(posedge clk);
            #1;
            wren = 0;
            rdaddress = 4'hF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Check Write Enable behavior...");
            reset_dut();

            wraddress = 4'h0;
            data = 8'hA5;
            wren = 1;
            @(posedge clk);
            #1;

            data = 8'h55;
            wren = 0;
            @(posedge clk);
            #1;

            rdaddress = 4'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Overwriting memory...");
            reset_dut();

            wraddress = 4'h2;
            data = 8'h11;
            wren = 1;
            @(posedge clk);
            #1;

            data = 8'h22;
            @(posedge clk);
            #1;
            wren = 0;
            rdaddress = 4'h2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Dual address operation...");
            reset_dut();

            wraddress = 4'h1;
            data = 8'hAA;
            wren = 1;
            @(posedge clk);
            #1;

            wraddress = 4'h2;
            data = 8'hBB;
            rdaddress = 4'h1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA);
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
        $dumpvars(0,clk, data, rdaddress, wraddress, wren, q);
    end

endmodule
