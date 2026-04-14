`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ack_in;
    reg c;
    reg clk;
    reg data_read;
    reg req;
    reg req_sent;
    reg reset;
    reg slave_in;
    wire [1:0] req_stat;
    wire slave_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ack_in(ack_in),
        .c(c),
        .clk(clk),
        .data_read(data_read),
        .req(req),
        .req_sent(req_sent),
        .reset(reset),
        .slave_in(slave_in),
        .req_stat(req_stat),
        .slave_out(slave_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            req = 0;
            slave_in = 0;
            c = 0;
            ack_in = 0;
            req_sent = 0;
            data_read = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(NO_REQ, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            req = 1;
            #1;

            check_outputs(WAIT, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            req = 1;
            @(posedge clk); #1;
            req_sent = 1;
            #1;

            check_outputs(W_ACK, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            req = 1;
            @(posedge clk); #1;
            req_sent = 1;
            @(posedge clk); #1;
            ack_in = 1;
            #1;

            check_outputs(W_DATA, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            req = 1;
            @(posedge clk); #1;
            req_sent = 1;
            @(posedge clk); #1;
            ack_in = 1;
            @(posedge clk); #1;
            data_read = 1;
            #1;

            check_outputs(NO_REQ, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            req = 1;
            slave_in = 1;
            c = 1;
            @(posedge clk); #1;
            req_sent = 1;
            @(posedge clk); #1;

            ack_in = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(W_DATA, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            req = 1;
            @(posedge clk); #1;
            req_sent = 0;
            @(posedge clk); #1;
            @(posedge clk); #1;
            #1;

            check_outputs(WAIT, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            req = 1;
            @(posedge clk); #1;
            req_sent = 1;
            @(posedge clk); #1;
            reset = 1;
            #1;

            check_outputs(NO_REQ, 0);
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
        testcase008();
        
        
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
        input [1:0] expected_req_stat;
        input expected_slave_out;
        begin
            if (expected_req_stat === (expected_req_stat ^ req_stat ^ expected_req_stat) &&
                expected_slave_out === (expected_slave_out ^ slave_out ^ expected_slave_out)) begin
                $display("PASS");
                $display("  Outputs: req_stat=%h, slave_out=%b",
                         req_stat, slave_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: req_stat=%h, slave_out=%b",
                         expected_req_stat, expected_slave_out);
                $display("  Got:      req_stat=%h, slave_out=%b",
                         req_stat, slave_out);
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
        $dumpvars(0,ack_in, c, clk, data_read, req, req_sent, reset, slave_in, req_stat, slave_out);
    end

endmodule
