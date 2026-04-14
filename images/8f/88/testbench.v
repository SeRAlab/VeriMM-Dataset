`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg carga;
    reg clk;
    reg d;
    reg reset;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .carga(carga),
        .clk(clk),
        .d(d),
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            carga = 0;
            d = 0;
            #10;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Asynchronous Reset");
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Load High (carga=1, d=1)");
            reset_dut();
            @(negedge clk);
            d = 1;
            carga = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Load Low (carga=1, d=0)");
            reset_dut();

            @(negedge clk);
            d = 1; carga = 1;
            @(posedge clk);
            #2;

            @(negedge clk);
            d = 0; carga = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Enable check (carga=0, hold 1)");
            reset_dut();

            @(negedge clk);
            d = 1; carga = 1;
            @(posedge clk);
            #2;

            @(negedge clk);
            d = 0; carga = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Enable check (carga=0, hold 0)");
            reset_dut();

            @(negedge clk);
            d = 0; carga = 1;
            @(posedge clk);
            #2;

            @(negedge clk);
            d = 1; carga = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Asynchronous reset mid-cycle");
            reset_dut();

            @(negedge clk);
            d = 1; carga = 1;
            @(posedge clk);
            #2;

            #3;
            reset = 1;
            #1;
            #1;

            check_outputs(1'b0);
            reset = 0;
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Reset priority over carga");
            reset_dut();
            @(negedge clk);
            d = 1;
            carga = 1;
            reset = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
            reset = 0;
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
        $dumpvars(0,carga, clk, d, reset, q);
    end

endmodule
