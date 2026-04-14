`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] cmd;
    reg reset;
    wire green;
    wire left;
    wire red;
    wire yellow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .cmd(cmd),
        .reset(reset),
        .green(green),
        .left(left),
        .red(red),
        .yellow(yellow)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            cmd = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: System Reset", test_num);
            reset_dut();

            #1;


            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Command 0 (Red Light)", test_num);
            reset_dut();
            cmd = 3'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Command 1 (Yellow Light)", test_num);
            reset_dut();
            cmd = 3'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Command 2 (Green Light)", test_num);
            reset_dut();
            cmd = 3'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Command 3 (Green + Left)", test_num);
            reset_dut();
            cmd = 3'd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 1, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Command 4 (Green + Yellow)", test_num);
            reset_dut();
            cmd = 3'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Command 5 (Invalid -> Red)", test_num);
            reset_dut();
            cmd = 3'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Command 7 (Invalid -> Red)", test_num);
            reset_dut();
            cmd = 3'd7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 1, 0);
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
        input expected_green;
        input expected_left;
        input expected_red;
        input expected_yellow;
        begin
            if (expected_green === (expected_green ^ green ^ expected_green) &&
                expected_left === (expected_left ^ left ^ expected_left) &&
                expected_red === (expected_red ^ red ^ expected_red) &&
                expected_yellow === (expected_yellow ^ yellow ^ expected_yellow)) begin
                $display("PASS");
                $display("  Outputs: green=%b, left=%b, red=%b, yellow=%b",
                         green, left, red, yellow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: green=%b, left=%b, red=%b, yellow=%b",
                         expected_green, expected_left, expected_red, expected_yellow);
                $display("  Got:      green=%b, left=%b, red=%b, yellow=%b",
                         green, left, red, yellow);
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
        $dumpvars(0,clk, cmd, reset, green, left, red, yellow);
    end

endmodule
