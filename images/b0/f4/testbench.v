`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg async_set;
    reg clk;
    reg [31:0] d;
    reg sync_set;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .async_set(async_set),
        .clk(clk),
        .d(d),
        .sync_set(sync_set),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        async_set = 0;
        forever #5 async_set = ~async_set;
    end

        task reset_dut;

        begin
            async_set = 0;
            sync_set = 0;
            d = 32'h0;


            async_set = 1;
            #2;
            async_set = 0;
            @(posedge clk);
            d = 32'h0;
            sync_set = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Testing Asynchronous Set (Immediate)", test_num);
            d = 32'hAAAA_AAAA;
            #2;
            async_set = 1;
            #1;
            #1;

            check_outputs(32'hFFFF_FFFF);
            async_set = 0;
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Testing Synchronous Set", test_num);
            d = 32'h5555_5555;
            sync_set = 1;

            if (q === 32'hFFFF_FFFF) $display("Warning: Sync set acting asynchronously!");
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Testing Normal Data Load", test_num);
            d = 32'h1234_5678;
            sync_set = 0;
            async_set = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Testing Async Set Priority over Sync/Data", test_num);
            d = 32'h0;
            sync_set = 1;
            #2;
            async_set = 1;
            #1;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Testing Data Load after Set release", test_num);

            async_set = 1;
            #5;
            async_set = 0;
            d = 32'hCAFE_BABE;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hCAFE_BABE);
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
        input [31:0] expected_q;
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
        $dumpvars(0,async_set, clk, d, sync_set, q);
    end

endmodule
