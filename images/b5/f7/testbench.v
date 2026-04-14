`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] io;
    wire [7:0] d0;
    wire [7:0] d1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .io(io),
        .d0(d0),
        .d1(d1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            io = 8'h00;

            @(posedge clk);
            @(negedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Dual-Edge Sampling", test_num);
            reset_dut();


            io = 8'hAA;
            @(posedge clk);
            #2;


            io = 8'h55;
            @(negedge clk);
            #2;

            #1;


            check_outputs(8'hAA, 8'h55);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sampling All Zeros and All Ones", test_num);
            reset_dut();

            io = 8'hFF;
            @(posedge clk);
            #2;

            io = 8'h00;
            @(negedge clk);
            #2;

            #1;


            check_outputs(8'hFF, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Identical Values on Both Edges", test_num);
            reset_dut();

            io = 8'h3C;
            @(posedge clk);
            #1;

            @(negedge clk);
            #2;

            #1;


            check_outputs(8'h3C, 8'h3C);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Rapid Data Change Before Edges", test_num);
            reset_dut();


            io = 8'h11;
            #2;
            io = 8'h22;
            @(posedge clk);
            #1;

            io = 8'h33;
            #2;
            io = 8'h44;
            @(negedge clk);
            #2;

            #1;


            check_outputs(8'h22, 8'h44);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Successive Clock Cycles", test_num);
            reset_dut();


            io = 8'hA1;
            @(posedge clk);
            io = 8'hB2;
            @(negedge clk);


            io = 8'hC3;
            @(posedge clk);
            io = 8'hD4;
            @(negedge clk);
            #2;


            #1;



            check_outputs(8'hC3, 8'hD4);
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
        input [7:0] expected_d0;
        input [7:0] expected_d1;
        begin
            if (expected_d0 === (expected_d0 ^ d0 ^ expected_d0) &&
                expected_d1 === (expected_d1 ^ d1 ^ expected_d1)) begin
                $display("PASS");
                $display("  Outputs: d0=%h, d1=%h",
                         d0, d1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d0=%h, d1=%h",
                         expected_d0, expected_d1);
                $display("  Got:      d0=%h, d1=%h",
                         d0, d1);
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
        $dumpvars(0,clk, io, d0, d1);
    end

endmodule
