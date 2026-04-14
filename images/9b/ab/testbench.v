`timescale 1ns/1ps

module binary_counter_sync_async_reset_tb;

    // Testbench signals (sequential circuit)
    reg async_reset;
    reg clk;
    reg sync_reset;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_counter_sync_async_reset dut (
        .async_reset(async_reset),
        .clk(clk),
        .sync_reset(sync_reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        async_reset = 0;
        forever #5 async_reset = ~async_reset;
    end

        task reset_dut;

        begin
            sync_reset = 0;
            async_reset = 1;
            #12;
            async_reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Asynchronous Reset");
            reset_dut();

            #2;
            async_reset = 1;
            #1;
            #1;

            check_outputs(4'b0000);
            async_reset = 0;
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Basic Increment");
            reset_dut();
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Synchronous Reset");
            reset_dut();
            @(posedge clk);
            @(posedge clk);
            sync_reset = 1;
            @(posedge clk);
            sync_reset = 0;
            #1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Testcase 004: Counter Rollover");
            reset_dut();

            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Precedence Check (Sync over Async)");
            reset_dut();
            @(posedge clk);



            sync_reset = 1;
            async_reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000);
            sync_reset = 0;
            async_reset = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_counter_sync_async_reset Testbench");
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
        input [3:0] expected_q;
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
        $dumpvars(0,async_reset, clk, sync_reset, q);
    end

endmodule
