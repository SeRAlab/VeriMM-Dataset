`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] channel_enable;
    reg [1:0] channel_select;
    reg clk;
    reg reset;
    reg start_transfer;
    wire transfer_complete;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_enable(channel_enable),
        .channel_select(channel_select),
        .clk(clk),
        .reset(reset),
        .start_transfer(start_transfer),
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
        channel_enable = 4'b0000;
        channel_select = 2'b00;
        start_transfer = 0;
        #20;
        reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test %03d: Start Transfer Channel 0 (Enabled)", test_num);
        reset_dut();
        channel_enable = 4'b0001;
        channel_select = 2'b00;
        @(posedge clk);
        start_transfer = 1;
        @(posedge clk);
        start_transfer = 0;


        repeat(5) @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %03d: Start Transfer Channel 1 (Enabled)", test_num);
        reset_dut();
        channel_enable = 4'b0010;
        channel_select = 2'b01;
        @(posedge clk);
        start_transfer = 1;
        @(posedge clk);
        start_transfer = 0;

        repeat(5) @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %03d: Start Transfer Channel 2 (Enabled)", test_num);
        reset_dut();
        channel_enable = 4'b0100;
        channel_select = 2'b10;
        @(posedge clk);
        start_transfer = 1;
        @(posedge clk);
        start_transfer = 0;

        repeat(5) @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %03d: Start Transfer Channel 3 (Enabled)", test_num);
        reset_dut();
        channel_enable = 4'b1000;
        channel_select = 2'b11;
        @(posedge clk);
        start_transfer = 1;
        @(posedge clk);
        start_transfer = 0;

        repeat(5) @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %03d: Attempt Transfer Channel 0 (Disabled)", test_num);
        reset_dut();
        channel_enable = 4'b1110;
        channel_select = 2'b00;
        @(posedge clk);
        start_transfer = 1;
        @(posedge clk);
        start_transfer = 0;

        repeat(5) @(posedge clk);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %03d: Multiple Channels Enabled, Select Channel 2", test_num);
        reset_dut();
        channel_enable = 4'b1111;
        channel_select = 2'b10;
        @(posedge clk);
        start_transfer = 1;
        @(posedge clk);
        start_transfer = 0;

        repeat(5) @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %03d: Start Transfer with No Channels Enabled", test_num);
        reset_dut();
        channel_enable = 4'b0000;
        channel_select = 2'b01;
        @(posedge clk);
        start_transfer = 1;
        @(posedge clk);
        start_transfer = 0;

        repeat(5) @(posedge clk);
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
        $display("dma_controller Testbench");
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
        input expected_transfer_complete;
        begin
            if (expected_transfer_complete === (expected_transfer_complete ^ transfer_complete ^ expected_transfer_complete)) begin
                $display("PASS");
                $display("  Outputs: transfer_complete=%b",
                         transfer_complete);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: transfer_complete=%b",
                         expected_transfer_complete);
                $display("  Got:      transfer_complete=%b",
                         transfer_complete);
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
        $dumpvars(0,channel_enable, channel_select, clk, reset, start_transfer, transfer_complete);
    end

endmodule
