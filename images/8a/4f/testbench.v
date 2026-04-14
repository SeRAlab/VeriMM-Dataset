`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg dbg_clk;
    reg dbg_rst;
    reg mem_burst;
    wire cmd_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dbg_clk(dbg_clk),
        .dbg_rst(dbg_rst),
        .mem_burst(mem_burst),
        .cmd_valid(cmd_valid)
    );

    // Clock generation (10ns period)
    initial begin
        dbg_clk = 0;
        forever #5 dbg_clk = ~dbg_clk;
    end

        task reset_dut;

        begin
            dbg_rst = 1;
            mem_burst = 0;
            @(posedge dbg_clk);
            #1;
            dbg_rst = 0;
            @(posedge dbg_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Reset State (RX_SYNC)", test_num);
            reset_dut();

            #1;


            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Command State (RX_CMD)", test_num);
            reset_dut();



            @(posedge dbg_clk);
            #1;


            #1;



            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Data State via Burst (RX_DATA)", test_num);
            reset_dut();


            @(posedge dbg_clk);
            #1;


            mem_burst = 1;
            @(posedge dbg_clk);
            #1;


            #1;



            check_outputs(0);
            mem_burst = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Return to Sync from CMD", test_num);
            reset_dut();


            @(posedge dbg_clk);
            #1;


            mem_burst = 0;
            @(posedge dbg_clk);
            #1;


            #1;



            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Full Sequence (Sync->CMD->Data->Sync)", test_num);
            reset_dut();


            @(posedge dbg_clk);
            mem_burst = 1;


            @(posedge dbg_clk);
            mem_burst = 0;


            @(posedge dbg_clk);
            #1;


            #1;



            check_outputs(0);
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
        input expected_cmd_valid;
        begin
            if (expected_cmd_valid === (expected_cmd_valid ^ cmd_valid ^ expected_cmd_valid)) begin
                $display("PASS");
                $display("  Outputs: cmd_valid=%b",
                         cmd_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cmd_valid=%b",
                         expected_cmd_valid);
                $display("  Got:      cmd_valid=%b",
                         cmd_valid);
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
        $dumpvars(0,dbg_clk, dbg_rst, mem_burst, cmd_valid);
    end

endmodule
