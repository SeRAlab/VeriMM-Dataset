`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [31:0] dataa;
    reg [31:0] datab;
    reg enable;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .dataa(dataa),
        .datab(datab),
        .enable(enable),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            enable = 0;
            dataa = 0;
            datab = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Positive * Positive (15 * 10)", test_num);
            dataa = 32'd15;
            datab = 32'd10;
            enable = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(32'd150);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Negative * Positive (-15 * 10)", test_num);
            dataa = -32'd15;
            datab = 32'd10;
            enable = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(-32'd150);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Positive * Negative (20 * -5)", test_num);
            dataa = 32'd20;
            datab = -32'd5;
            enable = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(-32'd100);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Negative * Negative (-12 * -4)", test_num);
            dataa = -32'd12;
            datab = -32'd4;
            enable = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(32'd48);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication by Zero (0 * -1234)", test_num);
            dataa = 32'd0;
            datab = -32'd1234;
            enable = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Enable Logic Check", test_num);


            dataa = 32'd5;
            datab = 32'd5;
            enable = 1;
            @(posedge clock);
            #2;


            enable = 0;
            dataa = 32'd10;
            datab = 32'd10;
            @(posedge clock);
            #2;


            #1;



            check_outputs(32'd25);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Max Positive Signed * 1", test_num);
            dataa = 32'h7FFFFFFF;
            datab = 32'd1;
            enable = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(32'h7FFFFFFF);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Min Negative Signed * 1", test_num);
            dataa = 32'h80000000;
            datab = 32'd1;
            enable = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Truncation Check (2^16 * 2^16)", test_num);
            dataa = 32'h00010000;
            datab = 32'h00010000;
            enable = 1;
            @(posedge clock);
            #2;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Identity (-1 * -1)", test_num);
            dataa = -32'd1;
            datab = -32'd1;
            enable = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(32'd1);
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
        input [31:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,clock, dataa, datab, enable, result);
    end

endmodule
