`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] channel_select;
    reg clk;
    reg [23:0] dest_addr;
    reg enable;
    reg rst;
    reg [23:0] src_addr;
    reg transfer_request;
    wire transfer_complete;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_select(channel_select),
        .clk(clk),
        .dest_addr(dest_addr),
        .enable(enable),
        .rst(rst),
        .src_addr(src_addr),
        .transfer_request(transfer_request),
        .transfer_complete(transfer_complete)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        enable = 0;
        channel_select = 2'b00;
        src_addr = 24'h0;
        dest_addr = 24'h0;
        transfer_request = 0;
        @(posedge clk);
        #5 rst = 0;
        @(posedge clk);
        $display("Reset Complete");
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %0d: Channel 0 Basic Transfer", test_num);

        enable = 1;
        channel_select = 2'b00;
        src_addr = 24'hAAAAAA;
        dest_addr = 24'h111111;

        @(posedge clk);
        transfer_request = 1;
        @(posedge clk);
        transfer_request = 0;


        repeat(10) @(posedge clk);

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %0d: Channel 1 Basic Transfer", test_num);

        enable = 1;
        channel_select = 2'b01;
        src_addr = 24'hBBBBBB;
        dest_addr = 24'h222222;

        @(posedge clk);
        transfer_request = 1;
        @(posedge clk);
        transfer_request = 0;

        repeat(10) @(posedge clk);

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %0d: Request while DMA Disabled", test_num);

        enable = 0;
        channel_select = 2'b00;
        src_addr = 24'hCCCCCC;
        dest_addr = 24'h333333;

        @(posedge clk);
        transfer_request = 1;
        @(posedge clk);
        transfer_request = 0;

        repeat(10) @(posedge clk);


        #1;



        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %0d: Successive Transfers (Ch0 then Ch1)", test_num);

        enable = 1;


        channel_select = 2'b00;
        src_addr = 24'h101010;
        dest_addr = 24'h010101;
        @(posedge clk);
        transfer_request = 1;
        @(posedge clk);
        transfer_request = 0;
        repeat(10) @(posedge clk);


        channel_select = 2'b01;
        src_addr = 24'h202020;
        dest_addr = 24'h020202;
        @(posedge clk);
        transfer_request = 1;
        @(posedge clk);
        transfer_request = 0;
        repeat(10) @(posedge clk);

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %0d: Idle State (No request)", test_num);

        enable = 1;
        channel_select = 2'b00;
        transfer_request = 0;

        repeat(10) @(posedge clk);

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
        $dumpvars(0,channel_select, clk, dest_addr, enable, rst, src_addr, transfer_request, transfer_complete);
    end

endmodule
