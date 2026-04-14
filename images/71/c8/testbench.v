`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ct;
    reg itr;
    reg [31:0] x0;
    reg [31:0] x1;
    wire [31:0] y0;
    wire [31:0] y1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ct(ct),
        .itr(itr),
        .x0(x0),
        .x1(x1),
        .y0(y0),
        .y1(y1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            itr = 1;
            ct = 0;
            x0 = 0;
            x1 = 0;
            @(posedge clk);
            #2;
            itr = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: ct=0, Straight mapping", test_num);

            x0 = 32'hDEADBEEF;
            x1 = 32'hBAADF00D;
            ct = 0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hDEADBEEF, 32'hBAADF00D);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: ct=1, Swapped mapping", test_num);

            x0 = 32'h12345678;
            x1 = 32'h87654321;
            ct = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h87654321, 32'h12345678);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: ct=0, Zeros and Ones", test_num);

            x0 = 32'hFFFFFFFF;
            x1 = 32'h00000000;
            ct = 0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF, 32'h00000000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: ct=1, Alternating bits swapped", test_num);

            x0 = 32'hAAAAAAAA;
            x1 = 32'h55555555;
            ct = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h55555555, 32'hAAAAAAAA);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Change ct mid-operation", test_num);

            x0 = 32'hCAFEFACE;
            x1 = 32'hB0B0B0B0;
            ct = 0;
            @(posedge clk);
            #2;


            ct = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hB0B0B0B0, 32'hCAFEFACE);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Max boundary values", test_num);

            x0 = 32'hFFFF_FFFF;
            x1 = 32'hFFFF_FFFF;
            ct = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFF_FFFF, 32'hFFFF_FFFF);
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
        input [31:0] expected_y0;
        input [31:0] expected_y1;
        begin
            if (expected_y0 === (expected_y0 ^ y0 ^ expected_y0) &&
                expected_y1 === (expected_y1 ^ y1 ^ expected_y1)) begin
                $display("PASS");
                $display("  Outputs: y0=%h, y1=%h",
                         y0, y1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y0=%h, y1=%h",
                         expected_y0, expected_y1);
                $display("  Got:      y0=%h, y1=%h",
                         y0, y1);
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
        $dumpvars(0,clk, ct, itr, x0, x1, y0, y1);
    end

endmodule
