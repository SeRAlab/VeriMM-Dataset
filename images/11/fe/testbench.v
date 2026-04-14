`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] channel_select;
    reg clk;
    reg enable;
    wire [7:0] data_out;
    wire transfer_complete;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_select(channel_select),
        .clk(clk),
        .enable(enable),
        .data_out(data_out),
        .transfer_complete(transfer_complete)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        enable = 0;
        channel_select = 3'b000;
        repeat(2) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nRunning Testcase %0d: Channel 0 Transfer", test_num);
        reset_dut();

        channel_select = 3'd0;
        enable = 1;



        fork : wait_or_timeout_0
            begin
                wait(transfer_complete == 1'b1);
                disable wait_or_timeout_0;
            end
            begin
                repeat(50) @(posedge clk);
                disable wait_or_timeout_0;
            end
        join

        #1;

        #1;


        check_outputs(8'h00, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nRunning Testcase %0d: Channel 3 Transfer", test_num);
        reset_dut();

        channel_select = 3'd3;
        enable = 1;

        fork : wait_or_timeout_3
            begin
                wait(transfer_complete == 1'b1);
                disable wait_or_timeout_3;
            end
            begin
                repeat(50) @(posedge clk);
                disable wait_or_timeout_3;
            end
        join

        #1;

        #1;


        check_outputs(8'h03, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nRunning Testcase %0d: Channel 7 Transfer", test_num);
        reset_dut();

        channel_select = 3'd7;
        enable = 1;

        fork : wait_or_timeout_7
            begin
                wait(transfer_complete == 1'b1);
                disable wait_or_timeout_7;
            end
            begin
                repeat(50) @(posedge clk);
                disable wait_or_timeout_7;
            end
        join

        #1;
        #1;

        check_outputs(8'h07, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nRunning Testcase %0d: Disable Check", test_num);
        reset_dut();

        channel_select = 3'd2;
        enable = 0;

        repeat(10) @(posedge clk);

        #1;

        #1;


        check_outputs(8'h00, 1'b0);
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
        input [7:0] expected_data_out;
        input expected_transfer_complete;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_transfer_complete === (expected_transfer_complete ^ transfer_complete ^ expected_transfer_complete)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, transfer_complete=%b",
                         data_out, transfer_complete);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, transfer_complete=%b",
                         expected_data_out, expected_transfer_complete);
                $display("  Got:      data_out=%h, transfer_complete=%b",
                         data_out, transfer_complete);
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
        $dumpvars(0,channel_select, clk, enable, data_out, transfer_complete);
    end

endmodule
