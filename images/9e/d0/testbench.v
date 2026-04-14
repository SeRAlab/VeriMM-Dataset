`timescale 1ns/1ps

module sync_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg reset;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sync_counter dut (
        .clk(clk),
        .en(en),
        .reset(reset),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            en = 0;
            @(negedge clk);
            reset = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Reset logic");
            reset_dut();
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Increment by 1");
            reset_dut();
            @(negedge clk);
            en = 1;
            @(negedge clk);
            en = 0;
            #1;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Test Case 003: Count to 5");
            reset_dut();
            @(negedge clk);
            en = 1;
            for(i=0; i<5; i=i+1) begin
                @(negedge clk);
            end
            en = 0;
            #1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Enable/Disable behavior");
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat(2) @(negedge clk);
            en = 0;
            repeat(3) @(negedge clk);
            #1;
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Test Case 005: Full wrap-around");
            reset_dut();
            @(negedge clk);
            en = 1;
            for(i=0; i<16; i=i+1) begin
                @(negedge clk);
            end
            en = 0;
            #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Synchronous Reset priority");
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat(8) @(negedge clk);
            reset = 1;
            @(negedge clk);
            reset = 0;
            en = 0;
            #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        integer i;
        begin
            $display("Test Case 007: Count to Max (15)");
            reset_dut();
            @(negedge clk);
            en = 1;
            for(i=0; i<15; i=i+1) begin
                @(negedge clk);
            end
            en = 0;
            #1;
            #1;

            check_outputs(4'hF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sync_counter Testbench");
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
        input [3:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, en, reset, count);
    end

endmodule
