`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] sample0;
    reg [7:0] sample1;
    reg [7:0] sample2;
    reg [7:0] sample3;
    reg [6:0] vol0;
    reg [6:0] vol1;
    reg [6:0] vol2;
    reg [6:0] vol3;
    wire [14:0] ldatasum;
    wire [14:0] rdatasum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .sample0(sample0),
        .sample1(sample1),
        .sample2(sample2),
        .sample3(sample3),
        .vol0(vol0),
        .vol1(vol1),
        .vol2(vol2),
        .vol3(vol3),
        .ldatasum(ldatasum),
        .rdatasum(rdatasum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            sample0 = 0; sample1 = 0; sample2 = 0; sample3 = 0;
            vol0 = 0; vol1 = 0; vol2 = 0; vol3 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            reset_dut();
            sample0 = 0; vol0 = 0;
            sample1 = 0; vol1 = 0;
            sample2 = 0; vol2 = 0;
            sample3 = 0; vol3 = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(15'd0, 15'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Channel Active", test_num);
            reset_dut();
            sample0 = 8'd100; vol0 = 7'd50;
            sample1 = 0; vol1 = 0;
            sample2 = 0; vol2 = 0;
            sample3 = 0; vol3 = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(15'd5000, 15'd5000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple Channels Mixed", test_num);
            reset_dut();
            sample0 = 8'd10;  vol0 = 7'd10;
            sample1 = 8'd20;  vol1 = 7'd10;
            sample2 = 8'd30;  vol2 = 7'd10;
            sample3 = 8'd40;  vol3 = 7'd10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(15'd1000, 15'd1000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Single Channel Scaling", test_num);
            reset_dut();
            sample0 = 8'hFF; vol0 = 7'h7F;
            sample1 = 0; vol1 = 0;
            sample2 = 0; vol2 = 0;
            sample3 = 0; vol3 = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(15'd32385, 15'd32385);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Balanced Mid-Range Mix", test_num);
            reset_dut();
            sample0 = 8'd128; vol0 = 7'd32;
            sample1 = 8'd128; vol1 = 7'd32;
            sample2 = 8'd128; vol2 = 7'd32;
            sample3 = 8'd128; vol3 = 7'd32;
            @(posedge clk);
            #2;
            #1;

            check_outputs(15'd16384, 15'd16384);
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
        input [14:0] expected_ldatasum;
        input [14:0] expected_rdatasum;
        begin
            if (expected_ldatasum === (expected_ldatasum ^ ldatasum ^ expected_ldatasum) &&
                expected_rdatasum === (expected_rdatasum ^ rdatasum ^ expected_rdatasum)) begin
                $display("PASS");
                $display("  Outputs: ldatasum=%h, rdatasum=%h",
                         ldatasum, rdatasum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ldatasum=%h, rdatasum=%h",
                         expected_ldatasum, expected_rdatasum);
                $display("  Got:      ldatasum=%h, rdatasum=%h",
                         ldatasum, rdatasum);
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
        $dumpvars(0,clk, sample0, sample1, sample2, sample3, vol0, vol1, vol2, vol3, ldatasum, rdatasum);
    end

endmodule
