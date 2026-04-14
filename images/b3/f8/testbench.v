`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg carryin;
    reg clk;
    reg clkb;
    reg in0;
    reg in1;
    reg in2;
    reg in3;
    reg sr;
    wire carryout;
    wire lcout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .carryin(carryin),
        .clk(clk),
        .clkb(clkb),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .sr(sr),
        .carryout(carryout),
        .lcout(lcout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            sr = 1;
            clkb = 1;
            carryin = 0;
            in0 = 0; in1 = 0; in2 = 0; in3 = 0;
            repeat (2) @(posedge clk);
            #1 sr = 0;
            #1 clkb = 0;
            #5 clkb = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            in0 = 0; in1 = 0; in2 = 0; in3 = 0; carryin = 0;
            sr = 0; clkb = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            in0 = 1; in1 = 0; in2 = 0; in3 = 0; carryin = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            in0 = 0; in1 = 0; in2 = 0; in3 = 1; carryin = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            in0 = 1; in1 = 1; in2 = 1; in3 = 1; carryin = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            in0 = 0; in1 = 0; in2 = 0; in3 = 0; carryin = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            in0 = 1; in1 = 1; in2 = 1; in3 = 1; carryin = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;

            in0 = 1; in1 = 1; in2 = 1; in3 = 1; carryin = 1;
            sr = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            in0 = 1; in1 = 1; in2 = 1; in3 = 1; carryin = 1;
            @(posedge clk);
            #2;

            clkb = 0;
            #2;
            #1;

            check_outputs(0, 0);
            clkb = 1;
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            in0 = 0; in1 = 1; in2 = 1; in3 = 0; carryin = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = 10;
            in0 = 1; in1 = 1; in2 = 1; in3 = 0; carryin = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 1);
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
        input expected_carryout;
        input expected_lcout;
        begin
            if (expected_carryout === (expected_carryout ^ carryout ^ expected_carryout) &&
                expected_lcout === (expected_lcout ^ lcout ^ expected_lcout)) begin
                $display("PASS");
                $display("  Outputs: carryout=%b, lcout=%b",
                         carryout, lcout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carryout=%b, lcout=%b",
                         expected_carryout, expected_lcout);
                $display("  Got:      carryout=%b, lcout=%b",
                         carryout, lcout);
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
        $dumpvars(0,carryin, clk, clkb, in0, in1, in2, in3, sr, carryout, lcout);
    end

endmodule
