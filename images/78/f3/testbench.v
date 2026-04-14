`timescale 1ns/1ps

module async_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg async_reset;
    reg clk;
    reg enable;
    wire [19:0] count_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    async_down_counter dut (
        .async_reset(async_reset),
        .clk(clk),
        .enable(enable),
        .count_out(count_out)
    );

    // Clock generation (10ns period)
    initial begin
        async_reset = 0;
        forever #5 async_reset = ~async_reset;
    end

        task reset_dut;

        begin
            async_reset = 1;
            enable = 0;
            #12;
            async_reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset behavior check", test_num);
            reset_dut();

            #1;


            check_outputs(20'hFFFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Counting down for 10 cycles", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            repeat (10) @(posedge clk);
            enable = 0;
            #1;

            #1;


            check_outputs(20'hFFFF5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable toggle check (Stalling)", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            repeat (5) @(posedge clk);
            enable = 0;
            repeat (5) @(posedge clk);
            enable = 1;
            repeat (2) @(posedge clk);
            enable = 0;
            #1;

            #1;


            check_outputs(20'hFFFF8);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large count sequence (1000 cycles)", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            repeat (1000) @(posedge clk);
            enable = 0;
            #1;

            #1;


            check_outputs(20'hFFC17);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Asynchronous reset mid-operation", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            repeat (20) @(posedge clk);

            #3;
            async_reset = 1;
            #10;
            async_reset = 0;
            #1;

            #1;


            check_outputs(20'hFFFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("async_down_counter Testbench");
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
        input [19:0] expected_count_out;
        begin
            if (expected_count_out === (expected_count_out ^ count_out ^ expected_count_out)) begin
                $display("PASS");
                $display("  Outputs: count_out=%h",
                         count_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_out=%h",
                         expected_count_out);
                $display("  Got:      count_out=%h",
                         count_out);
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
        $dumpvars(0,async_reset, clk, enable, count_out);
    end

endmodule
