`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [3:0] sat;
    wire [7:0] alt;
    wire [15:0] lat;
    wire [15:0] lon;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .sat(sat),
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
            reset = 1;
            sat = 4'b0000;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Power-on Reset Verification", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input Sensitivity (sat = 4'hA)", test_num);
            reset_dut();
            sat = 4'hA;
            @(posedge clk);
            #2;




            #1;





            check_outputs(8'h0A, 16'h0AAA, 16'h0AAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum Satellite Input (sat = 4'hF)", test_num);
            reset_dut();
            sat = 4'hF;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hFF, 16'hFFFF, 16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Consecutive Updates", test_num);
            reset_dut();


            sat = 4'h1;
            @(posedge clk);
            #2;


            sat = 4'h2;
            @(posedge clk);
            #2;


            #1;



            check_outputs(8'h02, 16'h0002, 16'h0002);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mid-operation Reset Check", test_num);
            reset_dut();

            sat = 4'h5;
            @(posedge clk);
            #2;


            reset = 1;
            @(posedge clk);
            #2;
            reset = 0;


            #1;



            check_outputs(8'h00, 16'h0000, 16'h0000);
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
        input [7:0] expected_alt;
        input [15:0] expected_lat;
        input [15:0] expected_lon;
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
        $dumpvars(0,clk, reset, sat, alt, lat, lon);
    end

endmodule
