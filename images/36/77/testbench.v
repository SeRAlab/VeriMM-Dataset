`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] channel_select;
    reg clk;
    reg reset;
    reg start_transfer;
    wire [2:0] current_channel;
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
        .start_transfer(start_transfer),
        .current_channel(current_channel),
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
        start_transfer = 0;
        channel_select = 3'b000;
        @(posedge clk);
        #2 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Test %0d: Check Idle State After Reset", test_num);

        #1;


        check_outputs(3'b000, 1'b0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Test %0d: Transfer on Channel 3", test_num);
        channel_select = 3'd3;
        start_transfer = 1;
        @(posedge clk);
        start_transfer = 0;


        wait(transfer_complete == 1'b1);
        #1;

        check_outputs(3'd3, 1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Test %0d: Transfer on Boundary Channel 7", test_num);
        channel_select = 3'd7;
        start_transfer = 1;
        @(posedge clk);
        start_transfer = 0;

        wait(transfer_complete == 1'b1);
        #1;

        check_outputs(3'd7, 1'b1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Test %0d: Sequential Transfers (Ch 1 then Ch 2)", test_num);


        channel_select = 3'd1;
        start_transfer = 1;
        @(posedge clk);
        start_transfer = 0;
        wait(transfer_complete == 1'b1);
        @(posedge clk);


        channel_select = 3'd2;
        start_transfer = 1;
        @(posedge clk);
        start_transfer = 0;
        wait(transfer_complete == 1'b1);

        #1;


        check_outputs(3'd2, 1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Test %0d: Transfer on Channel 0", test_num);
        channel_select = 3'd0;
        start_transfer = 1;
        @(posedge clk);
        start_transfer = 0;

        wait(transfer_complete == 1'b1);
        #1;

        check_outputs(3'd0, 1'b1);
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
        input [2:0] expected_current_channel;
        input expected_transfer_complete;
        begin
            if (expected_current_channel === (expected_current_channel ^ current_channel ^ expected_current_channel) &&
                expected_transfer_complete === (expected_transfer_complete ^ transfer_complete ^ expected_transfer_complete)) begin
                $display("PASS");
                $display("  Outputs: current_channel=%h, transfer_complete=%b",
                         current_channel, transfer_complete);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_channel=%h, transfer_complete=%b",
                         expected_current_channel, expected_transfer_complete);
                $display("  Got:      current_channel=%h, transfer_complete=%b",
                         current_channel, transfer_complete);
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
        $dumpvars(0,channel_select, clk, reset, start_transfer, current_channel, transfer_complete);
    end

endmodule
