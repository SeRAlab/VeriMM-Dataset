`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] bin;
    reg clk;
    wire [3:0] dec0;
    wire [3:0] dec1;
    wire [3:0] dec2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bin(bin),
        .clk(clk),
        .dec0(dec0),
        .dec1(dec1),
        .dec2(dec2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            bin <= 8'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Binary 0", test_num);
            reset_dut();
            bin <= 8'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Binary 255", test_num);
            reset_dut();
            bin <= 8'd255;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd5, 4'd5, 4'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Binary 7", test_num);
            reset_dut();
            bin <= 8'd7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd7, 4'd0, 4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Binary 42", test_num);
            reset_dut();
            bin <= 8'd42;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd2, 4'd4, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Binary 100", test_num);
            reset_dut();
            bin <= 8'd100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 4'd0, 4'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Binary 123", test_num);
            reset_dut();
            bin <= 8'd123;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3, 4'd2, 4'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Binary 209", test_num);
            reset_dut();
            bin <= 8'd209;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd9, 4'd0, 4'd2);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Binary 128", test_num);
            reset_dut();
            bin <= 8'd128;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd8, 4'd2, 4'd1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Binary 99", test_num);
            reset_dut();
            bin <= 8'd99;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd9, 4'd9, 4'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Binary 199", test_num);
            reset_dut();
            bin <= 8'd199;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd9, 4'd9, 4'd1);
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
        testcase009();
        testcase010();
        
        
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
        input [3:0] expected_dec0;
        input [3:0] expected_dec1;
        input [3:0] expected_dec2;
        begin
            if (expected_dec0 === (expected_dec0 ^ dec0 ^ expected_dec0) &&
                expected_dec1 === (expected_dec1 ^ dec1 ^ expected_dec1) &&
                expected_dec2 === (expected_dec2 ^ dec2 ^ expected_dec2)) begin
                $display("PASS");
                $display("  Outputs: dec0=%h, dec1=%h, dec2=%h",
                         dec0, dec1, dec2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dec0=%h, dec1=%h, dec2=%h",
                         expected_dec0, expected_dec1, expected_dec2);
                $display("  Got:      dec0=%h, dec1=%h, dec2=%h",
                         dec0, dec1, dec2);
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
        $dumpvars(0,bin, clk, dec0, dec1, dec2);
    end

endmodule
