`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] channel_select;
    reg clk;
    reg reset;
    reg start;
    wire [2:0] active_channel;
    wire transfer_complete;

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
        .active_channel(active_channel),
        .transfer_complete(transfer_complete)
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
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Starting DMA transfer on Channel 0");
            reset_dut();
            channel_select = 3'b000;
            start = 1;
            @(posedge clk);
            #1 start = 0;


            repeat (5) @(posedge clk);

            #1;


            check_outputs(3'b000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Starting DMA transfer on Channel 7");
            reset_dut();
            channel_select = 3'b111;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            repeat (5) @(posedge clk);

            #1;


            check_outputs(3'b111, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Starting DMA transfer on Channel 3");
            reset_dut();
            channel_select = 3'b011;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            repeat (5) @(posedge clk);

            #1;


            check_outputs(3'b011, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Starting DMA transfer on Channel 5");
            reset_dut();
            channel_select = 3'b101;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            repeat (5) @(posedge clk);

            #1;


            check_outputs(3'b101, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Verifying Idle state after Reset");
            reset_dut();


            #1;



            check_outputs(3'b000, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Starting DMA transfer on Channel 2");
            reset_dut();
            channel_select = 3'b010;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            repeat (5) @(posedge clk);

            #1;


            check_outputs(3'b010, 1'b1);
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
        input [2:0] expected_active_channel;
        input expected_transfer_complete;
        begin
            if (expected_active_channel === (expected_active_channel ^ active_channel ^ expected_active_channel) &&
                expected_transfer_complete === (expected_transfer_complete ^ transfer_complete ^ expected_transfer_complete)) begin
                $display("PASS");
                $display("  Outputs: active_channel=%h, transfer_complete=%b",
                         active_channel, transfer_complete);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: active_channel=%h, transfer_complete=%b",
                         expected_active_channel, expected_transfer_complete);
                $display("  Got:      active_channel=%h, transfer_complete=%b",
                         active_channel, transfer_complete);
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
        $dumpvars(0,channel_select, clk, reset, start, active_channel, transfer_complete);
    end

endmodule
