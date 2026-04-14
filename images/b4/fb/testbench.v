`timescale 1ns/1ps

module counter_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg rst;
    wire [7:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter_8bit dut (
        .clk(clk),
        .enable(enable),
        .rst(rst),
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
            rst = 1;
            enable = 0;
            @(negedge clk);
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Reset Verification", test_num);
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Increment Test", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            @(negedge clk);
            enable = 0;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase %0d: Multiple Increments (15 cycles)", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            for (i = 0; i < 15; i = i + 1) begin
                @(negedge clk);
            end
            enable = 0;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %0d: Enable Gating (Pause Logic)", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            for (i = 0; i < 5; i = i + 1) @(negedge clk);
            enable = 0;
            for (i = 0; i < 5; i = i + 1) @(negedge clk);
            #1;

            check_outputs(8'h05);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase %0d: Synchronous Reset Priority", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            for (i = 0; i < 10; i = i + 1) @(negedge clk);
            rst = 1;
            @(negedge clk);
            rst = 0;
            enable = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Testcase %0d: Counter Rollover (256 increments)", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            for (i = 0; i < 256; i = i + 1) begin
                @(negedge clk);
            end
            enable = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = 7;
            $display("Testcase %0d: Increment after Rollover", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            for (i = 0; i < 258; i = i + 1) begin
                @(negedge clk);
            end
            enable = 0;
            #1;

            check_outputs(8'h02);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter_8bit Testbench");
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
        input [7:0] expected_count;
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
        $dumpvars(0,clk, enable, rst, count);
    end

endmodule
