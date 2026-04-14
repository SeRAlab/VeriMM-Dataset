`timescale 1ns/1ps

module md5_transform_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] data_in;
    reg rst;
    wire [127:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    md5_transform dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        data_in = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase 001: All Zeros");
        reset_dut();
        data_in = 128'h0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(md5_model(128'h0));
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase 002: All Ones");
        reset_dut();
        data_in = {4{32'hFFFFFFFF}};
        @(posedge clk);
        #2;
        #1;

        check_outputs(md5_model({4{32'hFFFFFFFF}}));
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase 003: Sequential Pattern");
        reset_dut();
        data_in = 128'h0123456789ABCDEFFEDCBA9876543210;
        @(posedge clk);
        #2;
        #1;

        check_outputs(md5_model(128'h0123456789ABCDEFFEDCBA9876543210));
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase 004: Walking Ones");
        reset_dut();
        data_in = 128'h80000000400000002000000010000000;
        @(posedge clk);
        #2;
        #1;

        check_outputs(md5_model(128'h80000000400000002000000010000000));
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running Testcase 005: Alternating Bits");
        reset_dut();
        data_in = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
        @(posedge clk);
        #2;
        #1;

        check_outputs(md5_model(128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA));
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("md5_transform Testbench");
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
        input [127:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, rst, data_out);
    end

endmodule
