`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg cein;
    reg clk;
    reg enable;
    reg wdogdis;
    reg [7:0] wdogdivreg;
    reg wdreset;
    wire wdtripce;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cein(cein),
        .clk(clk),
        .enable(enable),
        .wdogdis(wdogdis),
        .wdogdivreg(wdogdivreg),
        .wdreset(wdreset),
        .wdtripce(wdtripce)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            cein = 0;
            enable = 0;
            wdogdis = 1;
            wdogdivreg = 8'h00;
            wdreset = 0;
            @(posedge clk);
            wdreset = 1;
            @(posedge clk);
            wdreset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            wdogdivreg = 8'h05;
            wdogdis = 0;
            enable = 1;
            cein = 1;


            repeat(10) @(posedge clk);

            $display("Testcase 001: Normal Trip");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            wdogdivreg = 8'h0A;
            wdogdis = 0;
            enable = 1;
            cein = 1;


            repeat(7) @(posedge clk);


            wdreset = 1;
            @(posedge clk);
            wdreset = 0;


            repeat(5) @(posedge clk);

            $display("Testcase 002: Watchdog Reset");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            wdogdivreg = 8'h05;
            wdogdis = 1;
            enable = 1;
            cein = 1;

            repeat(15) @(posedge clk);

            $display("Testcase 003: Watchdog Disable");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            wdogdivreg = 8'h05;
            wdogdis = 0;
            enable = 0;
            cein = 1;

            repeat(15) @(posedge clk);

            $display("Testcase 004: Global Enable Low");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            wdogdivreg = 8'h05;
            wdogdis = 0;
            enable = 1;
            cein = 0;

            repeat(20) @(posedge clk);

            $display("Testcase 005: cein Low");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            wdogdivreg = 8'h20;
            wdogdis = 0;
            enable = 1;
            cein = 1;

            repeat(40) @(posedge clk);

            $display("Testcase 006: Large Divider Trip");
            #1;

            check_outputs(1'b1);
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
        input expected_wdtripce;
        begin
            if (expected_wdtripce === (expected_wdtripce ^ wdtripce ^ expected_wdtripce)) begin
                $display("PASS");
                $display("  Outputs: wdtripce=%b",
                         wdtripce);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wdtripce=%b",
                         expected_wdtripce);
                $display("  Got:      wdtripce=%b",
                         wdtripce);
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
        $dumpvars(0,cein, clk, enable, wdogdis, wdogdivreg, wdreset, wdtripce);
    end

endmodule
