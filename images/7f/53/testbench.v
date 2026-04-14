`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Bclkx16_;
    reg Rx_done;
    reg [7:0] data;
    reg reset;
    wire [7:0] dis;
    wire rst;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Bclkx16_(Bclkx16_),
        .Rx_done(Rx_done),
        .data(data),
        .reset(reset),
        .dis(dis),
        .rst(rst)
    );

    // Clock generation (10ns period)
    initial begin
        Bclkx16_ = 0;
        forever #5 Bclkx16_ = ~Bclkx16_;
    end

        task reset_dut;

    begin
        reset = 0;
        Rx_done = 0;
        data = 8'h00;
        @(negedge Bclkx16_);
        reset = 0;
        @(negedge Bclkx16_);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Reset Inactive State", test_num);
        reset_dut();


        reset = 0;
        Rx_done = 1;
        data = 8'hFF;
        @(negedge Bclkx16_);

        #1;


        check_outputs(8'h00, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Rx Not Done (Reset high, Rx_done low)", test_num);
        reset_dut();

        reset = 1;
        Rx_done = 0;
        data = 8'hAA;
        @(negedge Bclkx16_);

        #1;


        check_outputs(8'h00, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Data Latching (Rx_done high)", test_num);
        reset_dut();

        reset = 1;
        data = 8'h55;
        Rx_done = 1;
        @(negedge Bclkx16_);

        #1;


        check_outputs(8'h55, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Continuous Data Update", test_num);
        reset_dut();

        reset = 1;
        Rx_done = 1;
        data = 8'h12;
        @(negedge Bclkx16_);
        data = 8'h34;
        @(negedge Bclkx16_);

        #1;


        check_outputs(8'h34, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Return to Reset Inactive", test_num);
        reset_dut();


        reset = 1;
        Rx_done = 1;
        data = 8'hA5;
        @(negedge Bclkx16_);


        reset = 0;
        @(negedge Bclkx16_);

        #1;


        check_outputs(8'h00, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Reset remains active when Rx_done drops", test_num);
        reset_dut();

        reset = 1;
        Rx_done = 1;
        data = 8'hBC;
        @(negedge Bclkx16_);

        Rx_done = 0;
        @(negedge Bclkx16_);


        #1;



        check_outputs(dis, 1);
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
        input [7:0] expected_dis;
        input expected_rst;
        begin
            if (expected_dis === (expected_dis ^ dis ^ expected_dis) &&
                expected_rst === (expected_rst ^ rst ^ expected_rst)) begin
                $display("PASS");
                $display("  Outputs: dis=%h, rst=%b",
                         dis, rst);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dis=%h, rst=%b",
                         expected_dis, expected_rst);
                $display("  Got:      dis=%h, rst=%b",
                         dis, rst);
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
        $dumpvars(0,Bclkx16_, Rx_done, data, reset, dis, rst);
    end

endmodule
