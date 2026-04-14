`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg adc_rst;
    reg rx_clk;
    reg [127:0] rx_data;
    wire adc_clk;
    wire [55:0] adc_data_a;
    wire [55:0] adc_data_b;
    wire adc_or_a;
    wire adc_or_b;
    wire adc_status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .adc_rst(adc_rst),
        .rx_clk(rx_clk),
        .rx_data(rx_data),
        .adc_clk(adc_clk),
        .adc_data_a(adc_data_a),
        .adc_data_b(adc_data_b),
        .adc_or_a(adc_or_a),
        .adc_or_b(adc_or_b),
        .adc_status(adc_status)
    );

    // Clock generation (10ns period)
    initial begin
        rx_clk = 0;
        forever #5 rx_clk = ~rx_clk;
    end

        task reset_dut;

    begin
        $display("Resetting DUT...");
        adc_rst = 1;
        rx_data = 128'h0;
        repeat(2) @(posedge rx_clk);
        #1;
        adc_rst = 0;
        repeat(1) @(posedge rx_clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: Basic Data Path Verification", test_num);
        reset_dut();



        rx_data[55:0]   = 56'hA1B2C3D4E5F607;
        rx_data[111:56] = 56'h89ABCDEF012345;
        rx_data[127:112]= 16'h0;

        repeat(1) @(posedge rx_clk);
        #1;


        #1;



        check_outputs(1, 56'hA1B2C3D4E5F607, 56'h89ABCDEF012345, 0, 0, 1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: Over-Range Flag Verification", test_num);
        reset_dut();


        rx_data[55:0]   = 56'h0;
        rx_data[111:56] = 56'h0;
        rx_data[112]    = 1;
        rx_data[113]    = 1;

        repeat(1) @(posedge rx_clk);
        #1;


        #1;



        check_outputs(1, 56'h0, 56'h0, 1, 1, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: Operational Status and Reset Verification", test_num);


        adc_rst = 1;
        rx_data = 128'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;
        repeat(2) @(posedge rx_clk);
        #1;



        #1;




        check_outputs(1, 56'h0, 56'h0, 0, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: Boundary Value Test (All Ones)", test_num);
        reset_dut();


        rx_data = 128'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;

        repeat(1) @(posedge rx_clk);
        #1;


        #1;



        check_outputs(1, 56'hFFFFFFFFFFFFFF, 56'hFFFFFFFFFFFFFF, 1, 1, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %0d: Alternating Bit Pattern", test_num);
        reset_dut();


        rx_data = 128'h5555_5555_5555_5555_5555_5555_5555_5555;

        repeat(1) @(posedge rx_clk);
        #1;

        #1;


        check_outputs(1, 56'h55555555555555, 56'h55555555555555, 0, 0, 1);
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
        input expected_adc_clk;
        input [55:0] expected_adc_data_a;
        input [55:0] expected_adc_data_b;
        input expected_adc_or_a;
        input expected_adc_or_b;
        input expected_adc_status;
        begin
            if (expected_adc_clk === (expected_adc_clk ^ adc_clk ^ expected_adc_clk) &&
                expected_adc_data_a === (expected_adc_data_a ^ adc_data_a ^ expected_adc_data_a) &&
                expected_adc_data_b === (expected_adc_data_b ^ adc_data_b ^ expected_adc_data_b) &&
                expected_adc_or_a === (expected_adc_or_a ^ adc_or_a ^ expected_adc_or_a) &&
                expected_adc_or_b === (expected_adc_or_b ^ adc_or_b ^ expected_adc_or_b) &&
                expected_adc_status === (expected_adc_status ^ adc_status ^ expected_adc_status)) begin
                $display("PASS");
                $display("  Outputs: adc_clk=%b, adc_data_a=%h, adc_data_b=%h, adc_or_a=%b, adc_or_b=%b, adc_status=%b",
                         adc_clk, adc_data_a, adc_data_b, adc_or_a, adc_or_b, adc_status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adc_clk=%b, adc_data_a=%h, adc_data_b=%h, adc_or_a=%b, adc_or_b=%b, adc_status=%b",
                         expected_adc_clk, expected_adc_data_a, expected_adc_data_b, expected_adc_or_a, expected_adc_or_b, expected_adc_status);
                $display("  Got:      adc_clk=%b, adc_data_a=%h, adc_data_b=%h, adc_or_a=%b, adc_or_b=%b, adc_status=%b",
                         adc_clk, adc_data_a, adc_data_b, adc_or_a, adc_or_b, adc_status);
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
        $dumpvars(0,adc_rst, rx_clk, rx_data, adc_clk, adc_data_a, adc_data_b, adc_or_a, adc_or_b, adc_status);
    end

endmodule
