`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] channel_select;
    reg clk;
    reg reset;
    reg start;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_select(channel_select),
        .clk(clk),
        .reset(reset),
        .start(start),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        start = 0;
        channel_select = 3'b000;
        @(posedge clk);
        #2 reset = 0;
        @(posedge clk);
        $display("DUT Reset Complete");
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Basic Transfer - Channel 0", test_num);
        reset_dut();


        channel_select = 3'd0;
        start = 1;
        @(posedge clk);
        start = 0;


        repeat(20) begin
            if (ready) break;
            @(posedge clk);
        end

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Basic Transfer - Channel 7", test_num);
        reset_dut();


        channel_select = 3'd7;
        start = 1;
        @(posedge clk);
        start = 0;


        repeat(20) begin
            if (ready) break;
            @(posedge clk);
        end

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Idle State (No Start)", test_num);
        reset_dut();


        channel_select = 3'd3;
        start = 0;


        repeat(10) @(posedge clk);

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Basic Transfer - Channel 4", test_num);
        reset_dut();


        channel_select = 3'd4;
        start = 1;
        @(posedge clk);
        start = 0;


        repeat(20) begin
            if (ready) break;
            @(posedge clk);
        end

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Channel Change without Reset", test_num);
        reset_dut();


        channel_select = 3'd1;
        start = 1;
        @(posedge clk);
        start = 0;

        repeat(20) begin
            if (ready) break;
            @(posedge clk);
        end


        channel_select = 3'd2;
        start = 1;
        @(posedge clk);
        start = 0;

        repeat(20) begin
            if (ready) break;
            @(posedge clk);
        end

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
        $display("dma_controller Testbench");
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
        input expected_ready;
        begin
            if (expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: ready=%b",
                         ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ready=%b",
                         expected_ready);
                $display("  Got:      ready=%b",
                         ready);
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
        $dumpvars(0,channel_select, clk, reset, start, ready);
    end

endmodule
