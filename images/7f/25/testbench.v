`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] async_data;
    reg clk;
    reg reset;
    wire async_ack;
    wire [1:0] sync_data;
    wire sync_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .async_data(async_data),
        .clk(clk),
        .reset(reset),
        .async_ack(async_ack),
        .sync_data(sync_data),
        .sync_en(sync_en)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            async_data = 4'b0000;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %03d: System Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 2'b00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %03d: Data Pattern 1010", test_num);
            reset_dut();
            async_data = 4'b1010;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 2'b10, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %03d: Data Pattern 0101", test_num);
            reset_dut();
            async_data = 4'b0101;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 2'b01, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %03d: All Zeros Input", test_num);
            reset_dut();
            async_data = 4'b0000;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 2'b00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %03d: High Nibble Pattern 1100", test_num);
            reset_dut();
            async_data = 4'b1100;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 2'b00, 1'b1);
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
        input expected_async_ack;
        input [1:0] expected_sync_data;
        input expected_sync_en;
        begin
            if (expected_async_ack === (expected_async_ack ^ async_ack ^ expected_async_ack) &&
                expected_sync_data === (expected_sync_data ^ sync_data ^ expected_sync_data) &&
                expected_sync_en === (expected_sync_en ^ sync_en ^ expected_sync_en)) begin
                $display("PASS");
                $display("  Outputs: async_ack=%b, sync_data=%h, sync_en=%b",
                         async_ack, sync_data, sync_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: async_ack=%b, sync_data=%h, sync_en=%b",
                         expected_async_ack, expected_sync_data, expected_sync_en);
                $display("  Got:      async_ack=%b, sync_data=%h, sync_en=%b",
                         async_ack, sync_data, sync_en);
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
        $dumpvars(0,async_data, clk, reset, async_ack, sync_data, sync_en);
    end

endmodule
