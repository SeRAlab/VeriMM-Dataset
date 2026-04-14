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
            wdreset = 1;
            wdogdis = 0;
            wdogdivreg = 8'h00;
            @(posedge clk);
            #1;
            wdreset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Timeout Trigger", test_num);
            reset_dut();

            wdogdivreg = 8'd5;
            enable = 1;
            wdogdis = 0;
            cein = 1;


            repeat (5) @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Watchdog Reset Mid-count", test_num);
            reset_dut();

            wdogdivreg = 8'd10;
            enable = 1;
            wdogdis = 0;
            cein = 1;


            repeat (5) @(posedge clk);


            wdreset = 1;
            @(posedge clk);
            #1;
            wdreset = 0;


            repeat (3) @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Watchdog Disabled", test_num);
            reset_dut();

            wdogdivreg = 8'd4;
            enable = 1;
            wdogdis = 1;
            cein = 1;


            repeat (10) @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Enable Signal Logic", test_num);
            reset_dut();

            wdogdivreg = 8'd5;
            enable = 0;
            wdogdis = 0;
            cein = 1;


            repeat (10) @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Trip Recovery via Reset", test_num);
            reset_dut();

            wdogdivreg = 8'd3;
            enable = 1;
            wdogdis = 0;
            cein = 1;


            repeat (3) @(posedge clk);
            #1;


            if (wdtripce !== 1'b1) $display("  Intermediate Check Failed: Trip not active");


            wdreset = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: High Division Value (255)", test_num);
            reset_dut();

            wdogdivreg = 8'hFF;
            enable = 1;
            wdogdis = 0;
            cein = 1;


            repeat (255) @(posedge clk);
            #2;

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
