`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [31:0] dataa;
    reg [31:0] datab;
    wire [63:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .dataa(dataa),
        .datab(datab),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            dataa = 32'd0;
            datab = 32'd0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            dataa = 32'sd10;
            datab = 32'sd20;

            @(posedge clock);
            @(posedge clock);
            #1;
            #1;

            check_outputs(64'sd200);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            dataa = 32'sd15;
            datab = -32'sd10;
            @(posedge clock);
            @(posedge clock);
            #1;
            #1;

            check_outputs(-64'sd150);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            dataa = -32'sd25;
            datab = 32'sd4;
            @(posedge clock);
            @(posedge clock);
            #1;
            #1;

            check_outputs(-64'sd100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            dataa = -32'sd8;
            datab = -32'sd7;
            @(posedge clock);
            @(posedge clock);
            #1;
            #1;

            check_outputs(64'sd56);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            dataa = 32'hFFFFFFFF;
            datab = 32'd0;
            @(posedge clock);
            @(posedge clock);
            #1;
            #1;

            check_outputs(64'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            dataa = 32'h7FFFFFFF;
            datab = 32'sd2;
            @(posedge clock);
            @(posedge clock);
            #1;
            #1;

            check_outputs(64'sd4294967294);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            dataa = 32'h80000000;
            datab = 32'sd1;
            @(posedge clock);
            @(posedge clock);
            #1;
            #1;

            check_outputs(-64'sd2147483648);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            dataa = 32'h80000000;
            datab = -32'sd1;
            @(posedge clock);
            @(posedge clock);
            #1;
            #1;

            check_outputs(64'sd2147483648);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            dataa = 32'h7FFFFFFF;
            datab = 32'h7FFFFFFF;
            @(posedge clock);
            @(posedge clock);
            #1;
            #1;

            check_outputs(64'h3FFFFFFF00000001);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            dataa = 32'h80000000;
            datab = 32'h80000000;
            @(posedge clock);
            @(posedge clock);
            #1;
            #1;

            check_outputs(64'h4000000000000000);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            reset_dut();
            dataa = 32'sd123456;
            datab = -32'sd654321;
            @(posedge clock);
            @(posedge clock);
            #1;
            #1;

            check_outputs(-64'sd80779853376);
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
        testcase011();
        
        
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
        input [63:0] expected_result;
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
        $dumpvars(0,clock, dataa, datab, result);
    end

endmodule
