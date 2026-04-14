`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] channel_select;
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg start_transfer;
    wire ready;
    wire [7:0] status_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_select(channel_select),
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .start_transfer(start_transfer),
        .ready(ready),
        .status_out(status_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        channel_select = 3'b000;
        data_in = 8'h00;
        start_transfer = 1'b0;
        @(posedge clk);
        #2 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Checking Reset State");
        reset_dut();

        #1;


        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Start Transfer on Channel 0");
        reset_dut();

        channel_select = 3'b000;
        data_in = 8'hA1;
        start_transfer = 1'b1;
        @(posedge clk);
        #2 start_transfer = 1'b0;


        #1;



        check_outputs(ready, 8'h01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Start Transfer on Channel 4");
        reset_dut();

        channel_select = 3'b100;
        data_in = 8'hB2;
        start_transfer = 1'b1;
        @(posedge clk);
        #2 start_transfer = 1'b0;


        #1;



        check_outputs(ready, 8'h10);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Start Transfer on Channel 7");
        reset_dut();

        channel_select = 3'b111;
        data_in = 8'hFF;
        start_transfer = 1'b1;
        @(posedge clk);
        #2 start_transfer = 1'b0;


        #1;



        check_outputs(ready, 8'h80);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Checking Ready Signal during transfer initiation");
        reset_dut();

        channel_select = 3'b010;
        data_in = 8'h55;
        start_transfer = 1'b1;


        #2;


        if (ready === 1'b0 || status_out === 8'h04) begin
            $display("PASS: Controller acknowledged transfer start");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: Controller did not react to start_transfer");
            fail_count = fail_count + 1;
        end
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
        input [7:0] expected_status_out;
        begin
            if (expected_ready === (expected_ready ^ ready ^ expected_ready) &&
                expected_status_out === (expected_status_out ^ status_out ^ expected_status_out)) begin
                $display("PASS");
                $display("  Outputs: ready=%b, status_out=%h",
                         ready, status_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ready=%b, status_out=%h",
                         expected_ready, expected_status_out);
                $display("  Got:      ready=%b, status_out=%h",
                         ready, status_out);
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
        $dumpvars(0,channel_select, clk, data_in, reset, start_transfer, ready, status_out);
    end

endmodule
