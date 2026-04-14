`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] in;
    reg reset;
    wire [7:0] out_hi;
    wire [7:0] out_lo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .out_hi(out_hi),
        .out_lo(out_lo)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in = 16'h0000;
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
            $display("\nTestcase %0d: Reset Behavior", test_num);
            reset_dut();

            in = 16'hA5A5;
            #2;
            #1;

            check_outputs(8'hA5, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Data Load", test_num);
            reset_dut();
            in = 16'h1234;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h12, 8'h34);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Bits Set", test_num);
            reset_dut();
            in = 16'hFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hFF, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: HI update vs LO stability", test_num);
            reset_dut();
            in = 16'hBEEF;
            @(posedge clk);
            #2;

            in = 16'hCAFE;
            #2;

            #1;


            check_outputs(8'hCA, 8'hEF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sequential updates", test_num);
            reset_dut();

            in = 16'h1122;
            @(posedge clk);
            #2;

            in = 16'h3344;
            @(posedge clk);
            #2;

            in = 16'h5566;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h55, 8'h66);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset during operation", test_num);
            reset_dut();

            in = 16'hD00D;
            @(posedge clk);
            #2;


            reset = 1;
            #2;


            #1;



            check_outputs(8'hD0, 8'h00);
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
        input [7:0] expected_out_hi;
        input [7:0] expected_out_lo;
        begin
            if (expected_out_hi === (expected_out_hi ^ out_hi ^ expected_out_hi) &&
                expected_out_lo === (expected_out_lo ^ out_lo ^ expected_out_lo)) begin
                $display("PASS");
                $display("  Outputs: out_hi=%h, out_lo=%h",
                         out_hi, out_lo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_hi=%h, out_lo=%h",
                         expected_out_hi, expected_out_lo);
                $display("  Got:      out_hi=%h, out_lo=%h",
                         out_hi, out_lo);
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
        $dumpvars(0,clk, in, reset, out_hi, out_lo);
    end

endmodule
