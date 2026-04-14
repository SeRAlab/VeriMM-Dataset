`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dest_addr_channel1;
    reg [7:0] dest_addr_channel2;
    reg [7:0] num_bytes_channel1;
    reg [7:0] num_bytes_channel2;
    reg rst;
    reg [7:0] src_addr_channel1;
    reg [7:0] src_addr_channel2;
    reg start_channel1;
    reg start_channel2;
    wire busy_channel1;
    wire busy_channel2;
    wire done_channel1;
    wire done_channel2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .dest_addr_channel1(dest_addr_channel1),
        .dest_addr_channel2(dest_addr_channel2),
        .num_bytes_channel1(num_bytes_channel1),
        .num_bytes_channel2(num_bytes_channel2),
        .rst(rst),
        .src_addr_channel1(src_addr_channel1),
        .src_addr_channel2(src_addr_channel2),
        .start_channel1(start_channel1),
        .start_channel2(start_channel2),
        .busy_channel1(busy_channel1),
        .busy_channel2(busy_channel2),
        .done_channel1(done_channel1),
        .done_channel2(done_channel2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        start_channel1 = 0;
        start_channel2 = 0;
        src_addr_channel1 = 0;
        dest_addr_channel1 = 0;
        num_bytes_channel1 = 0;
        src_addr_channel2 = 0;
        dest_addr_channel2 = 0;
        num_bytes_channel2 = 0;
        repeat(2) @(posedge clk);
        #1 rst = 0;
        repeat(1) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Basic Channel 1 Transfer (5 bytes)", test_num);
        reset_dut();

        src_addr_channel1 = 8'h10;
        dest_addr_channel1 = 8'h50;
        num_bytes_channel1 = 8'd5;

        @(posedge clk);
        start_channel1 = 1;
        @(posedge clk);
        start_channel1 = 0;


        wait(done_channel1 == 1);
        @(posedge clk);


        #1;



        check_outputs(1'b0, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Basic Channel 2 Transfer (3 bytes)", test_num);
        reset_dut();

        src_addr_channel2 = 8'h20;
        dest_addr_channel2 = 8'h60;
        num_bytes_channel2 = 8'd3;

        @(posedge clk);
        start_channel2 = 1;
        @(posedge clk);
        start_channel2 = 0;

        wait(done_channel2 == 1);
        @(posedge clk);


        #1;



        check_outputs(1'b0, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Parallel Transfer (Ch1: 4 bytes, Ch2: 4 bytes)", test_num);
        reset_dut();

        src_addr_channel1 = 8'h01; dest_addr_channel1 = 8'h0A; num_bytes_channel1 = 8'd4;
        src_addr_channel2 = 8'h02; dest_addr_channel2 = 8'h0B; num_bytes_channel2 = 8'd4;

        @(posedge clk);
        start_channel1 = 1;
        start_channel2 = 1;
        @(posedge clk);
        start_channel1 = 0;
        start_channel2 = 0;


        wait(done_channel1 == 1 && done_channel2 == 1);
        @(posedge clk);

        #1;


        check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Parallel Transfer with Different Lengths (Ch1: 2, Ch2: 6)", test_num);
        reset_dut();

        src_addr_channel1 = 8'hAA; dest_addr_channel1 = 8'hBB; num_bytes_channel1 = 8'd2;
        src_addr_channel2 = 8'hCC; dest_addr_channel2 = 8'hDD; num_bytes_channel2 = 8'd6;

        @(posedge clk);
        start_channel1 = 1;
        start_channel2 = 1;
        @(posedge clk);
        start_channel1 = 0;
        start_channel2 = 0;


        wait(done_channel1 == 1 && done_channel2 == 1);
        @(posedge clk);

        #1;


        check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Overlapping Start (Ch2 starts after Ch1)", test_num);
        reset_dut();

        src_addr_channel1 = 8'h10; dest_addr_channel1 = 8'h20; num_bytes_channel1 = 8'd8;
        src_addr_channel2 = 8'h30; dest_addr_channel2 = 8'h40; num_bytes_channel2 = 8'd2;

        @(posedge clk);
        start_channel1 = 1;
        @(posedge clk);
        start_channel1 = 0;

        repeat(2) @(posedge clk);

        start_channel2 = 1;
        @(posedge clk);
        start_channel2 = 0;

        wait(done_channel1 == 1 && done_channel2 == 1);
        @(posedge clk);

        #1;


        check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
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
        input expected_busy_channel1;
        input expected_busy_channel2;
        input expected_done_channel1;
        input expected_done_channel2;
        begin
            if (expected_busy_channel1 === (expected_busy_channel1 ^ busy_channel1 ^ expected_busy_channel1) &&
                expected_busy_channel2 === (expected_busy_channel2 ^ busy_channel2 ^ expected_busy_channel2) &&
                expected_done_channel1 === (expected_done_channel1 ^ done_channel1 ^ expected_done_channel1) &&
                expected_done_channel2 === (expected_done_channel2 ^ done_channel2 ^ expected_done_channel2)) begin
                $display("PASS");
                $display("  Outputs: busy_channel1=%b, busy_channel2=%b, done_channel1=%b, done_channel2=%b",
                         busy_channel1, busy_channel2, done_channel1, done_channel2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy_channel1=%b, busy_channel2=%b, done_channel1=%b, done_channel2=%b",
                         expected_busy_channel1, expected_busy_channel2, expected_done_channel1, expected_done_channel2);
                $display("  Got:      busy_channel1=%b, busy_channel2=%b, done_channel1=%b, done_channel2=%b",
                         busy_channel1, busy_channel2, done_channel1, done_channel2);
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
        $dumpvars(0,clk, dest_addr_channel1, dest_addr_channel2, num_bytes_channel1, num_bytes_channel2, rst, src_addr_channel1, src_addr_channel2, start_channel1, start_channel2, busy_channel1, busy_channel2, done_channel1, done_channel2);
    end

endmodule
