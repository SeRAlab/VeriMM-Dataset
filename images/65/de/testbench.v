`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg async_dat_i;
    reg clk_i;
    reg rst_i;
    reg stage1_clk_en_i;
    reg stage1_rst_i;
    wire sync_dat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .async_dat_i(async_dat_i),
        .clk_i(clk_i),
        .rst_i(rst_i),
        .stage1_clk_en_i(stage1_clk_en_i),
        .stage1_rst_i(stage1_rst_i),
        .sync_dat_o(sync_dat_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_i = 1;
            stage1_rst_i = 1;
            stage1_clk_en_i = 0;
            async_dat_i = 0;
            @(posedge clk_i);
            #1;
            rst_i = 0;
            stage1_rst_i = 0;
            @(posedge clk_i);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Sync High", test_num);
            reset_dut();

            async_dat_i = 1;
            stage1_clk_en_i = 1;


            @(posedge clk_i);
            @(posedge clk_i);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Clock Enable (Disabled)", test_num);
            reset_dut();

            async_dat_i = 1;
            stage1_clk_en_i = 0;

            @(posedge clk_i);
            @(posedge clk_i);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Stage 1 Reset", test_num);
            reset_dut();

            async_dat_i = 1;
            stage1_clk_en_i = 1;
            stage1_rst_i = 1;

            @(posedge clk_i);
            @(posedge clk_i);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sync Low Signal", test_num);
            reset_dut();


            async_dat_i = 1;
            stage1_clk_en_i = 1;
            @(posedge clk_i);
            @(posedge clk_i);


            async_dat_i = 0;
            @(posedge clk_i);
            @(posedge clk_i);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Global Reset Asserted", test_num);
            reset_dut();

            async_dat_i = 1;
            stage1_clk_en_i = 1;
            @(posedge clk_i);

            rst_i = 1;
            @(posedge clk_i);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable Gating Logic", test_num);
            reset_dut();


            async_dat_i = 1;
            stage1_clk_en_i = 1;
            @(posedge clk_i);
            #1;




            async_dat_i = 0;
            stage1_clk_en_i = 0;
            @(posedge clk_i);
            #1;

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
        input expected_sync_dat_o;
        begin
            if (expected_sync_dat_o === (expected_sync_dat_o ^ sync_dat_o ^ expected_sync_dat_o)) begin
                $display("PASS");
                $display("  Outputs: sync_dat_o=%b",
                         sync_dat_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sync_dat_o=%b",
                         expected_sync_dat_o);
                $display("  Got:      sync_dat_o=%b",
                         sync_dat_o);
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
        $dumpvars(0,async_dat_i, clk_i, rst_i, stage1_clk_en_i, stage1_rst_i, sync_dat_o);
    end

endmodule
