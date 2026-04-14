`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg antenna_data;
    reg clk;
    reg rst;
    reg sat_data;
    wire [31:0] alt;
    wire [31:0] lat;
    wire [31:0] lon;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .antenna_data(antenna_data),
        .clk(clk),
        .rst(rst),
        .sat_data(sat_data),
        .alt(alt),
        .lat(lat),
        .lon(lon)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            sat_data = 0;
            antenna_data = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase%03d: Reset State Initialization", test_num);
            reset_dut();

            #1;


            check_outputs(32'h00000000, 32'h00000000, 32'h00000000);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            $display("Running Testcase%03d: Short Data Sequence Stimulation", test_num);
            reset_dut();


            for (i = 0; i < 32; i = i + 1) begin
                @(posedge clk);
                sat_data = (i % 2);
                antenna_data = (i % 3 == 0);
            end

            repeat(5) @(posedge clk);



            #1;




            check_outputs(32'h00000005, 32'h0000000A, 32'h0000000F);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Running Testcase%03d: Constant High Input Streams", test_num);
            reset_dut();

            sat_data = 1;
            antenna_data = 1;
            repeat(64) @(posedge clk);

            repeat(10) @(posedge clk);

            #1;


            check_outputs(32'hFFFFFFFF, 32'h11111111, 32'h22222222);
        end
        endtask

    task testcase004;

        integer i;
        reg [63:0] pattern_sat;
        reg [63:0] pattern_ant;
        begin
            test_num = 4;
            $display("Running Testcase%03d: Dynamic Pattern Stimulation", test_num);
            reset_dut();

            pattern_sat = 64'hA5A5_5A5A_FF00_AA55;
            pattern_ant = 64'h3C3C_C3C3_00FF_55AA;

            for (i = 0; i < 64; i = i + 1) begin
                @(posedge clk);
                sat_data = pattern_sat[i];
                antenna_data = pattern_ant[i];
            end

            repeat(20) @(posedge clk);

            #1;


            check_outputs(32'h12345678, 32'h87654321, 32'hABCDEF01);
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
        input [31:0] expected_alt;
        input [31:0] expected_lat;
        input [31:0] expected_lon;
        begin
            if (expected_alt === (expected_alt ^ alt ^ expected_alt) &&
                expected_lat === (expected_lat ^ lat ^ expected_lat) &&
                expected_lon === (expected_lon ^ lon ^ expected_lon)) begin
                $display("PASS");
                $display("  Outputs: alt=%h, lat=%h, lon=%h",
                         alt, lat, lon);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alt=%h, lat=%h, lon=%h",
                         expected_alt, expected_lat, expected_lon);
                $display("  Got:      alt=%h, lat=%h, lon=%h",
                         alt, lat, lon);
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
        $dumpvars(0,antenna_data, clk, rst, sat_data, alt, lat, lon);
    end

endmodule
