`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr;
    reg [2:0] channel_select;
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg start_transfer;
    wire [7:0] data_out;
    wire transfer_complete;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .addr(addr),
        .channel_select(channel_select),
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .start_transfer(start_transfer),
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
        reset = 1;
        addr = 0;
        channel_select = 0;
        data_in = 0;
        start_transfer = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Basic transfer on Channel 0", test_num);
        reset_dut();


        addr = 8'hA0;
        data_in = 8'hBC;
        channel_select = 3'd0;
        start_transfer = 1;

        @(posedge clk);
        start_transfer = 0;


        wait(transfer_complete == 1);

        #1;


        check_outputs(8'hBC, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Transfer on Channel 7", test_num);
        reset_dut();

        addr = 8'hF0;
        data_in = 8'h55;
        channel_select = 3'd7;
        start_transfer = 1;

        @(posedge clk);
        start_transfer = 0;

        wait(transfer_complete == 1);

        #1;


        check_outputs(8'h55, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Channel Independence (Ch2 vs Ch3)", test_num);
        reset_dut();


        addr = 8'h22;
        data_in = 8'h22;
        channel_select = 3'd2;
        start_transfer = 1;
        @(posedge clk);
        start_transfer = 0;
        wait(transfer_complete == 1);


        addr = 8'h33;
        data_in = 8'h33;
        channel_select = 3'd3;
        start_transfer = 1;
        @(posedge clk);
        start_transfer = 0;
        wait(transfer_complete == 1);


        #1;



        check_outputs(8'h33, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Max data value transfer (0xFF)", test_num);
        reset_dut();

        addr = 8'hFF;
        data_in = 8'hFF;
        channel_select = 3'd4;
        start_transfer = 1;

        @(posedge clk);
        start_transfer = 0;

        wait(transfer_complete == 1);

        #1;


        check_outputs(8'hFF, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Consecutive transfers on Channel 1", test_num);
        reset_dut();


        addr = 8'h11;
        data_in = 8'hAA;
        channel_select = 3'd1;
        start_transfer = 1;
        @(posedge clk);
        start_transfer = 0;
        wait(transfer_complete == 1);


        @(posedge clk);
        addr = 8'h12;
        data_in = 8'hBB;
        channel_select = 3'd1;
        start_transfer = 1;
        @(posedge clk);
        start_transfer = 0;
        wait(transfer_complete == 1);

        #1;


        check_outputs(8'hBB, 1'b1);
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
        $dumpvars(0,addr, channel_select, clk, data_in, reset, start_transfer, data_out, transfer_complete);
    end

endmodule
