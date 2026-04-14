`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] dest_addr_ch1;
    reg [15:0] dest_addr_ch2;
    reg rst;
    reg [15:0] src_addr_ch1;
    reg [15:0] src_addr_ch2;
    reg start_ch1;
    reg start_ch2;
    wire done_ch1;
    wire done_ch2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .dest_addr_ch1(dest_addr_ch1),
        .dest_addr_ch2(dest_addr_ch2),
        .rst(rst),
        .src_addr_ch1(src_addr_ch1),
        .src_addr_ch2(src_addr_ch2),
        .start_ch1(start_ch1),
        .start_ch2(start_ch2),
        .done_ch1(done_ch1),
        .done_ch2(done_ch2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        start_ch1 = 0;
        start_ch2 = 0;
        src_addr_ch1 = 16'h0;
        dest_addr_ch1 = 16'h0;
        src_addr_ch2 = 16'h0;
        dest_addr_ch2 = 16'h0;
        #20;
        rst = 0;
        #20;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Channel 1 Single Transfer", test_num);
        reset_dut();

        src_addr_ch1 = 16'h1000;
        dest_addr_ch1 = 16'h2000;
        @(posedge clk);
        start_ch1 = 1;
        @(posedge clk);
        start_ch1 = 0;


        fork: wait_ch1
            begin
                wait(done_ch1 == 1);
            end
            begin
                #500;
            end
        join_any
        disable wait_ch1;

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Channel 2 Single Transfer", test_num);
        reset_dut();

        src_addr_ch2 = 16'h3000;
        dest_addr_ch2 = 16'h4000;
        @(posedge clk);
        start_ch2 = 1;
        @(posedge clk);
        start_ch2 = 0;


        fork: wait_ch2
            begin
                wait(done_ch2 == 1);
            end
            begin
                #500;
            end
        join_any
        disable wait_ch2;

        #1;


        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Simultaneous Channel 1 & 2 Transfers", test_num);
        reset_dut();

        src_addr_ch1 = 16'h1111;
        dest_addr_ch1 = 16'h2222;
        src_addr_ch2 = 16'hAAAA;
        dest_addr_ch2 = 16'hBBBB;

        @(posedge clk);
        start_ch1 = 1;
        start_ch2 = 1;
        @(posedge clk);
        start_ch1 = 0;
        start_ch2 = 0;


        fork: wait_both
            begin
                wait(done_ch1 == 1 && done_ch2 == 1);
            end
            begin
                #1000;
            end
        join_any
        disable wait_both;

        #1;


        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Overlapping Transfers", test_num);
        reset_dut();

        src_addr_ch1 = 16'h5000;
        dest_addr_ch1 = 16'h6000;
        src_addr_ch2 = 16'h7000;
        dest_addr_ch2 = 16'h8000;

        @(posedge clk);
        start_ch1 = 1;
        @(posedge clk);
        start_ch1 = 0;


        repeat(2) @(posedge clk);
        start_ch2 = 1;
        @(posedge clk);
        start_ch2 = 0;


        fork: wait_overlap
            begin
                wait(done_ch1 == 1 && done_ch2 == 1);
            end
            begin
                #1000;
            end
        join_any
        disable wait_overlap;

        #1;


        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Sequential (Consecutive) Transfers", test_num);
        reset_dut();


        src_addr_ch1 = 16'h0001;
        dest_addr_ch1 = 16'h0002;
        @(posedge clk);
        start_ch1 = 1;
        @(posedge clk);
        start_ch1 = 0;
        wait(done_ch1 == 1);
        @(posedge clk);


        src_addr_ch2 = 16'h0003;
        dest_addr_ch2 = 16'h0004;
        @(posedge clk);
        start_ch2 = 1;
        @(posedge clk);
        start_ch2 = 0;
        wait(done_ch2 == 1);

        #1;


        check_outputs(1'b0, 1'b1);
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
        input expected_done_ch1;
        input expected_done_ch2;
        begin
            if (expected_done_ch1 === (expected_done_ch1 ^ done_ch1 ^ expected_done_ch1) &&
                expected_done_ch2 === (expected_done_ch2 ^ done_ch2 ^ expected_done_ch2)) begin
                $display("PASS");
                $display("  Outputs: done_ch1=%b, done_ch2=%b",
                         done_ch1, done_ch2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done_ch1=%b, done_ch2=%b",
                         expected_done_ch1, expected_done_ch2);
                $display("  Got:      done_ch1=%b, done_ch2=%b",
                         done_ch1, done_ch2);
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
        $dumpvars(0,clk, dest_addr_ch1, dest_addr_ch2, rst, src_addr_ch1, src_addr_ch2, start_ch1, start_ch2, done_ch1, done_ch2);
    end

endmodule
