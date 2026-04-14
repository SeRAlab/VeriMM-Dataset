`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg rx_core_clk;
    reg [63:0] rx_tdata;
    reg rx_tvalid;
    wire [13:0] adc0_sample0;
    wire [13:0] adc0_sample1;
    wire [13:0] adc1_sample0;
    wire [13:0] adc1_sample1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .rx_core_clk(rx_core_clk),
        .rx_tdata(rx_tdata),
        .rx_tvalid(rx_tvalid),
        .adc0_sample0(adc0_sample0),
        .adc0_sample1(adc0_sample1),
        .adc1_sample0(adc1_sample0),
        .adc1_sample1(adc1_sample1)
    );

    // Clock generation (10ns period)
    initial begin
        rx_core_clk = 0;
        forever #5 rx_core_clk = ~rx_core_clk;
    end

        task reset_dut;

        begin
            rx_tdata <= 64'h0;
            rx_tvalid <= 0;
            @(posedge rx_core_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Basic Mapping Check", test_num);
            reset_dut();


            rx_tdata <= 64'h0001_0002_0003_0004;
            rx_tvalid <= 1;
            @(posedge rx_core_clk);


            rx_tvalid <= 0;
            #1;

            #1;


            check_outputs(14'h0004, 14'h0003, 14'h0002, 14'h0001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Maximum 14-bit Values", test_num);
            reset_dut();


            rx_tdata <= 64'h3FFF_3FFF_3FFF_3FFF;
            rx_tvalid <= 1;
            @(posedge rx_core_clk);

            rx_tvalid <= 0;
            #1;
            #1;

            check_outputs(14'h3FFF, 14'h3FFF, 14'h3FFF, 14'h3FFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Bit Boundary Isolation", test_num);
            reset_dut();


            rx_tdata <= 64'hC000_C000_C000_C000;
            rx_tvalid <= 1;
            @(posedge rx_core_clk);

            rx_tvalid <= 0;
            #1;
            #1;

            check_outputs(14'h0000, 14'h0000, 14'h0000, 14'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Valid Signal Gating", test_num);
            reset_dut();


            rx_tdata <= 64'h1111_2222_3333_4444;
            rx_tvalid <= 1;
            @(posedge rx_core_clk);


            rx_tdata <= 64'hAAAA_BBBB_CCCC_DDDD;
            rx_tvalid <= 0;
            @(posedge rx_core_clk);

            #1;


            #1;



            check_outputs(14'h0444, 14'h3333, 14'h2222, 14'h1111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Alternating Bit Patterns", test_num);
            reset_dut();

            rx_tdata <= 64'hAAAA_5555_AAAA_5555;
            rx_tvalid <= 1;
            @(posedge rx_core_clk);

            rx_tvalid <= 0;
            #1;


            #1;



            check_outputs(14'h1555, 14'h2AAA, 14'h1555, 14'h2AAA);
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
        input [13:0] expected_adc0_sample0;
        input [13:0] expected_adc0_sample1;
        input [13:0] expected_adc1_sample0;
        input [13:0] expected_adc1_sample1;
        begin
            if (expected_adc0_sample0 === (expected_adc0_sample0 ^ adc0_sample0 ^ expected_adc0_sample0) &&
                expected_adc0_sample1 === (expected_adc0_sample1 ^ adc0_sample1 ^ expected_adc0_sample1) &&
                expected_adc1_sample0 === (expected_adc1_sample0 ^ adc1_sample0 ^ expected_adc1_sample0) &&
                expected_adc1_sample1 === (expected_adc1_sample1 ^ adc1_sample1 ^ expected_adc1_sample1)) begin
                $display("PASS");
                $display("  Outputs: adc0_sample0=%h, adc0_sample1=%h, adc1_sample0=%h, adc1_sample1=%h",
                         adc0_sample0, adc0_sample1, adc1_sample0, adc1_sample1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adc0_sample0=%h, adc0_sample1=%h, adc1_sample0=%h, adc1_sample1=%h",
                         expected_adc0_sample0, expected_adc0_sample1, expected_adc1_sample0, expected_adc1_sample1);
                $display("  Got:      adc0_sample0=%h, adc0_sample1=%h, adc1_sample0=%h, adc1_sample1=%h",
                         adc0_sample0, adc0_sample1, adc1_sample0, adc1_sample1);
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
        $dumpvars(0,rx_core_clk, rx_tdata, rx_tvalid, adc0_sample0, adc0_sample1, adc1_sample0, adc1_sample1);
    end

endmodule
