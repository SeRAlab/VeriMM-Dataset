`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg [7:0] dest_addr;
    reg rst;
    reg [7:0] src_addr;
    reg start;
    wire busy;
    wire done;
    wire error;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .data_in(data_in),
        .dest_addr(dest_addr),
        .rst(rst),
        .src_addr(src_addr),
        .start(start),
        .busy(busy),
        .done(done),
        .error(error)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        start = 0;
        src_addr = 8'h0;
        dest_addr = 8'h0;
        data_in = 16'h0;
        repeat(2) @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %03d: Basic Data Transfer", test_num);
        reset_dut();

        src_addr = 8'h0A;
        dest_addr = 8'h20;
        data_in = 16'hABCD;
        start = 1;

        @(posedge clk);
        #1 start = 0;


        fork : wait_done_001
            begin
                wait(done == 1 || error == 1);
            end
            begin
                repeat(20) @(posedge clk);
            end
        join_any
        disable wait_done_001;



        #1;




        check_outputs(0, 1, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %03d: Transfer with Different Parameters", test_num);
        reset_dut();

        src_addr = 8'hFF;
        dest_addr = 8'hEE;
        data_in = 16'h1234;
        start = 1;

        @(posedge clk);
        #1 start = 0;

        fork : wait_done_002
            begin
                wait(done == 1 || error == 1);
            end
            begin
                repeat(20) @(posedge clk);
            end
        join_any
        disable wait_done_002;


        #1;



        check_outputs(0, 1, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %03d: Reset During Transfer", test_num);
        reset_dut();

        src_addr = 8'h11;
        dest_addr = 8'h22;
        data_in = 16'h55AA;
        start = 1;

        @(posedge clk);
        #1 start = 0;


        wait(busy == 1);
        @(posedge clk);
        #1 rst = 1;
        repeat(2) @(posedge clk);
        #1 rst = 0;
        @(posedge clk);



        #1;




        check_outputs(0, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %03d: Successive Transfers", test_num);
        reset_dut();


        src_addr = 8'h01; dest_addr = 8'h02; data_in = 16'hAAAA;
        start = 1;
        @(posedge clk);
        #1 start = 0;
        wait(done == 1);
        @(posedge clk);


        src_addr = 8'h03; dest_addr = 8'h04; data_in = 16'hBBBB;
        start = 1;
        @(posedge clk);
        #1 start = 0;

        fork : wait_done_004
            begin
                wait(done == 1 || error == 1);
            end
            begin
                repeat(20) @(posedge clk);
            end
        join_any
        disable wait_done_004;


        #1;



        check_outputs(0, 1, 0);
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
        input expected_busy;
        input expected_done;
        input expected_error;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_done === (expected_done ^ done ^ expected_done) &&
                expected_error === (expected_error ^ error ^ expected_error)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, done=%b, error=%b",
                         busy, done, error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, done=%b, error=%b",
                         expected_busy, expected_done, expected_error);
                $display("  Got:      busy=%b, done=%b, error=%b",
                         busy, done, error);
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
        $dumpvars(0,clk, data_in, dest_addr, rst, src_addr, start, busy, done, error);
    end

endmodule
