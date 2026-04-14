`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] channel_sel;
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg start;
    wire [7:0] data_out;
    wire transfer_done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_sel(channel_sel),
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .start(start),
        .data_out(data_out),
        .transfer_done(transfer_done)
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
            channel_sel = 2'b00;
            data_in = 8'h00;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Channel 0 Transfer");
            reset_dut();

            @(posedge clk);
            channel_sel = 2'b00;
            data_in = 8'hA5;
            start = 1;

            @(posedge clk);
            start = 0;


            wait(transfer_done == 1'b1);
            @(posedge clk);

            #1;


            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Channel 1 Transfer");
            reset_dut();

            @(posedge clk);
            channel_sel = 2'b01;
            data_in = 8'h5A;
            start = 1;

            @(posedge clk);
            start = 0;

            wait(transfer_done == 1'b1);
            @(posedge clk);

            #1;


            check_outputs(8'h5A, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Channel 2 Transfer");
            reset_dut();

            @(posedge clk);
            channel_sel = 2'b10;
            data_in = 8'hFF;
            start = 1;

            @(posedge clk);
            start = 0;

            wait(transfer_done == 1'b1);
            @(posedge clk);

            #1;


            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Channel 3 Transfer");
            reset_dut();

            @(posedge clk);
            channel_sel = 2'b11;
            data_in = 8'h12;
            start = 1;

            @(posedge clk);
            start = 0;

            wait(transfer_done == 1'b1);
            @(posedge clk);

            #1;


            check_outputs(8'h12, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Zero Data Transfer on Channel 0");
            reset_dut();

            @(posedge clk);
            channel_sel = 2'b00;
            data_in = 8'h00;
            start = 1;

            @(posedge clk);
            start = 0;

            wait(transfer_done == 1'b1);
            @(posedge clk);

            #1;


            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Testcase 006: Verify state immediately after reset");
            reset_dut();

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
        input [7:0] expected_data_out;
        input expected_transfer_done;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_transfer_done === (expected_transfer_done ^ transfer_done ^ expected_transfer_done)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, transfer_done=%b",
                         data_out, transfer_done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, transfer_done=%b",
                         expected_data_out, expected_transfer_done);
                $display("  Got:      data_out=%h, transfer_done=%b",
                         data_out, transfer_done);
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
        $dumpvars(0,channel_sel, clk, data_in, reset, start, data_out, transfer_done);
    end

endmodule
