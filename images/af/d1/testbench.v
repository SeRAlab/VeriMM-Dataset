`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_s0;
    reg [15:0] data_s1;
    reg [15:0] data_s2;
    reg [15:0] data_s3;
    reg [15:0] data_s4;
    reg [15:0] data_s5;
    wire [15:0] mac_data_0;
    wire [15:0] mac_data_1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_s0(data_s0),
        .data_s1(data_s1),
        .data_s2(data_s2),
        .data_s3(data_s3),
        .data_s4(data_s4),
        .data_s5(data_s5),
        .mac_data_0(mac_data_0),
        .mac_data_1(mac_data_1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_s0 = 0;
            data_s1 = 0;
            data_s2 = 0;
            data_s3 = 0;
            data_s4 = 0;
            data_s5 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Small inputs...");
            reset_dut();


            data_s0 = 16'd1;
            data_s1 = 16'd2;
            data_s2 = 16'd3;
            data_s3 = 16'd4;
            data_s4 = 16'd5;
            data_s5 = 16'd6;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0021, 16'h0021);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: All zeros...");
            reset_dut();
            data_s0 = 16'h0;
            data_s1 = 16'h0;
            data_s2 = 16'h0;
            data_s3 = 16'h0;
            data_s4 = 16'h0;
            data_s5 = 16'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Large values (16-bit overflow)...");
            reset_dut();




            data_s0 = 16'd10000;
            data_s1 = 16'd10000;
            data_s2 = 16'd10000;
            data_s3 = 16'd10000;
            data_s4 = 16'd10000;
            data_s5 = 16'd10000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h86A0, 16'h06A0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Bit 15 isolation...");
            reset_dut();




            data_s2 = 16'd10000;
            data_s3 = 16'd2769;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h8001, 16'h0001);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: All inputs at max (0xFFFF)...");
            reset_dut();



            data_s0 = 16'hFFFF;
            data_s1 = 16'hFFFF;
            data_s2 = 16'hFFFF;
            data_s3 = 16'hFFFF;
            data_s4 = 16'hFFFF;
            data_s5 = 16'hFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFF6, 16'h7FF6);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Testing coefficient weighting (x3)...");
            reset_dut();

            data_s2 = 16'd1000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0BB8, 16'h0BB8);
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
        input [15:0] expected_mac_data_0;
        input [15:0] expected_mac_data_1;
        begin
            if (expected_mac_data_0 === (expected_mac_data_0 ^ mac_data_0 ^ expected_mac_data_0) &&
                expected_mac_data_1 === (expected_mac_data_1 ^ mac_data_1 ^ expected_mac_data_1)) begin
                $display("PASS");
                $display("  Outputs: mac_data_0=%h, mac_data_1=%h",
                         mac_data_0, mac_data_1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mac_data_0=%h, mac_data_1=%h",
                         expected_mac_data_0, expected_mac_data_1);
                $display("  Got:      mac_data_0=%h, mac_data_1=%h",
                         mac_data_0, mac_data_1);
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
        $dumpvars(0,clk, data_s0, data_s1, data_s2, data_s3, data_s4, data_s5, mac_data_0, mac_data_1);
    end

endmodule
