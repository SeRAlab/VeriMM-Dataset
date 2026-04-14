`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [31:0] dataa;
    reg [31:0] datab;
    reg enable;
    reg resetn;
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
        .resetn(resetn),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            resetn = 0;
            enable = 0;
            dataa = 0;
            datab = 0;
            @(posedge clock);
            #1;
            resetn = 1;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            dataa = 32'h3F800000;
            datab = 32'd1;
            enable = 1;
            #1;

            check_outputs(32'h40000000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            dataa = 32'h3F800000;
            datab = -32'd1;
            enable = 1;
            #1;

            check_outputs(32'h3F000000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            dataa = 32'h40600000;
            datab = 32'd2;
            enable = 1;
            #1;

            check_outputs(32'h41600000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            dataa = 32'h00000000;
            datab = 32'd10;
            enable = 1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            dataa = 32'h7F800000;
            datab = 32'd5;
            enable = 1;
            #1;

            check_outputs(32'h7F800000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            dataa = 32'h3F800000;
            datab = 32'd128;
            enable = 1;
            #1;

            check_outputs(32'h7F800000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            dataa = 32'h3F800000;
            datab = -32'd150;
            enable = 1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;

            dataa = 32'h3F800000;
            datab = 32'd1;
            enable = 1;
            @(posedge clock);
            #1;

            dataa = 32'h40000000;
            datab = 32'd5;
            enable = 0;
            #1;

            check_outputs(32'h40000000);
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
        $dumpvars(0,clock, dataa, datab, enable, resetn, result);
    end

endmodule
