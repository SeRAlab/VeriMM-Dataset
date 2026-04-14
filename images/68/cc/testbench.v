`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg async_preset;
    reg clk;
    reg [7:0] d;
    reg load_en;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .async_preset(async_preset),
        .clk(clk),
        .d(d),
        .load_en(load_en),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        async_preset = 0;
        forever #5 async_preset = ~async_preset;
    end

        task reset_dut;

        begin
            async_preset = 1;
            load_en = 0;
            d = 8'h00;
            #10;
            async_preset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Asynchronous Preset Check", test_num);

            async_preset = 1;
            #2;
            #1;

            check_outputs(8'hFF);
            async_preset = 0;
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Load (0xAA)", test_num);

            d = 8'hAA;
            load_en = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            d = 8'h55;
            load_en = 1;
            @(posedge clk);
            #1;

            test_num = test_num + 1;
            $display("Testcase %0d: Load Disable (Hold 0x55)", test_num);

            load_en = 0;
            d = 8'hFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Async Preset Priority Over Load", test_num);

            load_en = 1;
            d = 8'h12;
            @(posedge clk);
            #1;

            async_preset = 1;
            #1;
            #1;

            check_outputs(8'hFF);
            async_preset = 0;
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Loads", test_num);

            load_en = 1;
            d = 8'h11; @(posedge clk); #1;
            d = 8'h22; @(posedge clk); #1;
            d = 8'h33; @(posedge clk); #2;

            #1;


            check_outputs(8'h33);
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
        input [7:0] expected_q;
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
        $dumpvars(0,async_preset, clk, d, load_en, q);
    end

endmodule
