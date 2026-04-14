`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [11:0] dataa;
    reg [7:0] datab;
    wire [19:0] result;

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
        dataa = 0;
        datab = 0;
        @(posedge clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Zero inputs (0 * 0)", test_num);
        reset_dut();
        dataa = 12'd0;
        datab = 8'd0;
        @(posedge clock);
        #2;
        #1;

        check_outputs(20'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Minimum non-zero (1 * 1)", test_num);
        reset_dut();
        dataa = 12'd1;
        datab = 8'd1;
        @(posedge clock);
        #2;
        #1;

        check_outputs(20'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Maximum values (4095 * 255)", test_num);
        reset_dut();
        dataa = 12'hFFF;
        datab = 8'hFF;
        @(posedge clock);
        #2;
        #1;

        check_outputs(20'hFFFFF);



        #1;




        check_outputs(20'hFEF01);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Typical multiplication (123 * 45)", test_num);
        reset_dut();
        dataa = 12'd123;
        datab = 8'd45;
        @(posedge clock);
        #2;
        #1;

        check_outputs(20'd5535);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: High dataa, low datab (4000 * 2)", test_num);
        reset_dut();
        dataa = 12'd4000;
        datab = 8'd2;
        @(posedge clock);
        #2;
        #1;

        check_outputs(20'd8000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Low dataa, high datab (5 * 250)", test_num);
        reset_dut();
        dataa = 12'd5;
        datab = 8'd250;
        @(posedge clock);
        #2;
        #1;

        check_outputs(20'd1250);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Power of 2 (256 * 128)", test_num);
        reset_dut();
        dataa = 12'd256;
        datab = 8'd128;
        @(posedge clock);
        #2;
        #1;

        check_outputs(20'd32768);
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
        input [19:0] expected_result;
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
