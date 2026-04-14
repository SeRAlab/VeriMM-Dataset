`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg master_read_done_token;
    reg master_write_done_token;
    reg slave_clk;
    reg slave_read;
    reg slave_reset_n;
    reg slave_write;
    wire slave_read_request;
    wire slave_waitrequest;
    wire slave_write_request;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .master_read_done_token(master_read_done_token),
        .master_write_done_token(master_write_done_token),
        .slave_clk(slave_clk),
        .slave_read(slave_read),
        .slave_reset_n(slave_reset_n),
        .slave_write(slave_write),
        .slave_read_request(slave_read_request),
        .slave_waitrequest(slave_waitrequest),
        .slave_write_request(slave_write_request)
    );

    // Clock generation (10ns period)
    initial begin
        slave_clk = 0;
        forever #5 slave_clk = ~slave_clk;
    end

        task reset_dut;

    begin
        slave_reset_n = 0;
        master_read_done_token = 0;
        master_write_done_token = 0;
        slave_read = 0;
        slave_write = 0;
        repeat (2) @(posedge slave_clk);
        #1 slave_reset_n = 1;
        repeat (1) @(posedge slave_clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Initial IDLE check", test_num);
        reset_dut();

        #1;


        check_outputs(0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Enter READ_WAIT", test_num);
        reset_dut();
        @(posedge slave_clk);
        slave_read = 1;
        @(posedge slave_clk);
        #1;

        #1;


        check_outputs(1, 1, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Complete Read Operation", test_num);
        reset_dut();
        @(posedge slave_clk);
        slave_read = 1;
        @(posedge slave_clk);
        slave_read = 0;
        master_read_done_token = 1;
        @(posedge slave_clk);
        #1;

        #1;


        check_outputs(0, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Enter WRITE_WAIT", test_num);
        reset_dut();
        @(posedge slave_clk);
        slave_write = 1;
        @(posedge slave_clk);
        #1;

        #1;


        check_outputs(0, 1, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Complete Write Operation", test_num);
        reset_dut();
        @(posedge slave_clk);
        slave_write = 1;
        @(posedge slave_clk);
        slave_write = 0;
        master_write_done_token = 1;
        @(posedge slave_clk);
        #1;

        #1;


        check_outputs(0, 0, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Stay in READ_WAIT for multiple cycles", test_num);
        reset_dut();
        @(posedge slave_clk);
        slave_read = 1;
        @(posedge slave_clk);
        slave_read = 0;
        repeat (3) @(posedge slave_clk);
        #1;

        #1;


        check_outputs(1, 1, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Sequential Read then Write", test_num);
        reset_dut();

        @(posedge slave_clk);
        slave_read = 1;
        @(posedge slave_clk);
        slave_read = 0;
        master_read_done_token = 1;
        @(posedge slave_clk);
        #1;
        master_read_done_token = 0;

        slave_write = 1;
        @(posedge slave_clk);
        #1;

        #1;


        check_outputs(0, 1, 1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_slave_read_request;
        input expected_slave_waitrequest;
        input expected_slave_write_request;
        begin
            if (expected_slave_read_request === (expected_slave_read_request ^ slave_read_request ^ expected_slave_read_request) &&
                expected_slave_waitrequest === (expected_slave_waitrequest ^ slave_waitrequest ^ expected_slave_waitrequest) &&
                expected_slave_write_request === (expected_slave_write_request ^ slave_write_request ^ expected_slave_write_request)) begin
                $display("PASS");
                $display("  Outputs: slave_read_request=%b, slave_waitrequest=%b, slave_write_request=%b",
                         slave_read_request, slave_waitrequest, slave_write_request);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: slave_read_request=%b, slave_waitrequest=%b, slave_write_request=%b",
                         expected_slave_read_request, expected_slave_waitrequest, expected_slave_write_request);
                $display("  Got:      slave_read_request=%b, slave_waitrequest=%b, slave_write_request=%b",
                         slave_read_request, slave_waitrequest, slave_write_request);
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
        $dumpvars(0,master_read_done_token, master_write_done_token, slave_clk, slave_read, slave_reset_n, slave_write, slave_read_request, slave_waitrequest, slave_write_request);
    end

endmodule
