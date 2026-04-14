`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg b;
    reg carryin;
    reg clk;
    reg rst;
    wire carryout;
    wire [1:0] currentbitcount;
    wire currentcarryout;
    wire currentsum;
    wire isValid;
    wire [3:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .carryin(carryin),
        .clk(clk),
        .rst(rst),
        .carryout(carryout),
        .currentbitcount(currentbitcount),
        .currentcarryout(currentcarryout),
        .currentsum(currentsum),
        .isValid(isValid),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            a = 0;
            b = 0;
            carryin = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            a = 1; b = 1; carryin = 0; @(posedge clk);

            a = 1; b = 0; @(posedge clk);

            a = 0; b = 1; @(posedge clk);

            a = 0; b = 0; @(posedge clk);
            #1;

            #1;


            check_outputs(0, 2'b11, 0, 1, 1, 4'b1000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            a = 1; b = 1; carryin = 0; @(posedge clk);

            a = 1; b = 0; @(posedge clk);

            a = 1; b = 0; @(posedge clk);

            a = 1; b = 0; @(posedge clk);
            #1;

            #1;


            check_outputs(1, 2'b11, 1, 0, 1, 4'b0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            a = 1; b = 1; carryin = 1; @(posedge clk);

            a = 1; b = 1; @(posedge clk);

            a = 1; b = 1; @(posedge clk);

            a = 0; b = 0; @(posedge clk);
            #1;

            #1;


            check_outputs(0, 2'b11, 0, 1, 1, 4'b1111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            a = 0; b = 1; carryin = 0; @(posedge clk);

            a = 1; b = 0; @(posedge clk);

            a = 0; b = 1; @(posedge clk);

            a = 1; b = 0; @(posedge clk);
            #1;

            #1;


            check_outputs(0, 2'b11, 0, 1, 1, 4'b1111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            a = 0; b = 0; carryin = 0; @(posedge clk);
            a = 0; b = 0; @(posedge clk);
            a = 0; b = 0; @(posedge clk);
            a = 0; b = 0; @(posedge clk);
            #1;

            #1;


            check_outputs(0, 2'b11, 0, 0, 1, 4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            a = 1; b = 1; carryin = 1; @(posedge clk);
            a = 1; b = 1; @(posedge clk);
            a = 1; b = 1; @(posedge clk);
            a = 1; b = 1; @(posedge clk);
            #1;

            #1;


            check_outputs(1, 2'b11, 1, 1, 1, 4'b1111);
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
        input expected_carryout;
        input [1:0] expected_currentbitcount;
        input expected_currentcarryout;
        input expected_currentsum;
        input expected_isValid;
        input [3:0] expected_y;
        begin
            if (expected_carryout === (expected_carryout ^ carryout ^ expected_carryout) &&
                expected_currentbitcount === (expected_currentbitcount ^ currentbitcount ^ expected_currentbitcount) &&
                expected_currentcarryout === (expected_currentcarryout ^ currentcarryout ^ expected_currentcarryout) &&
                expected_currentsum === (expected_currentsum ^ currentsum ^ expected_currentsum) &&
                expected_isValid === (expected_isValid ^ isValid ^ expected_isValid) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: carryout=%b, currentbitcount=%h, currentcarryout=%b, currentsum=%b, isValid=%b, y=%h",
                         carryout, currentbitcount, currentcarryout, currentsum, isValid, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carryout=%b, currentbitcount=%h, currentcarryout=%b, currentsum=%b, isValid=%b, y=%h",
                         expected_carryout, expected_currentbitcount, expected_currentcarryout, expected_currentsum, expected_isValid, expected_y);
                $display("  Got:      carryout=%b, currentbitcount=%h, currentcarryout=%b, currentsum=%b, isValid=%b, y=%h",
                         carryout, currentbitcount, currentcarryout, currentsum, isValid, y);
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
        $dumpvars(0,a, b, carryin, clk, rst, carryout, currentbitcount, currentcarryout, currentsum, isValid, y);
    end

endmodule
