`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg i_async;
    reg i_clk;
    wire o_sync;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_async(i_async),
        .i_clk(i_clk),
        .o_sync(o_sync)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

        begin
            i_async = 0;

            @(posedge i_clk);
            @(negedge i_clk);
            @(posedge i_clk);
            @(negedge i_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Capture High Signal", test_num);
            reset_dut();

            i_async = 1;
            @(posedge i_clk);
            @(negedge i_clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Capture Low Signal", test_num);
            reset_dut();


            i_async = 1;
            @(posedge i_clk);
            @(negedge i_clk);


            i_async = 0;
            @(posedge i_clk);
            @(negedge i_clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Rising Edge Isolation", test_num);
            reset_dut();

            i_async = 1;
            @(posedge i_clk);
            #2;


            if (o_sync === 1'b0) begin
                @(negedge i_clk);
                #2;
                #1;

                check_outputs(1'b1);
            end else begin
                $display("FAIL: o_sync changed on rising edge instead of falling edge");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Hold Sampled Value", test_num);
            reset_dut();

            i_async = 1;
            @(posedge i_clk);
            #2 i_async = 0;

            @(negedge i_clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Toggles", test_num);
            reset_dut();


            i_async = 1; @(posedge i_clk); @(negedge i_clk);
            i_async = 0; @(posedge i_clk); @(negedge i_clk);
            i_async = 1; @(posedge i_clk); @(negedge i_clk);
            i_async = 0; @(posedge i_clk); @(negedge i_clk);

            #2;
            #1;

            check_outputs(1'b0);
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
        input expected_o_sync;
        begin
            if (expected_o_sync === (expected_o_sync ^ o_sync ^ expected_o_sync)) begin
                $display("PASS");
                $display("  Outputs: o_sync=%b",
                         o_sync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_sync=%b",
                         expected_o_sync);
                $display("  Got:      o_sync=%b",
                         o_sync);
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
        $dumpvars(0,i_async, i_clk, o_sync);
    end

endmodule
