`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] IOA;
    reg [7:0] IOB;
    reg clk;
    reg reset;
    wire [7:0] IOE;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IOA(IOA),
        .IOB(IOB),
        .clk(clk),
        .reset(reset),
        .IOE(IOE)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            IOA = 8'h00;
            IOB = 8'h00;
            @(posedge clk);
            #2;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset check", test_num);
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 3 * 2 = 6", test_num);
            reset_dut();
            IOA = 8'h03;
            IOB = 8'h02;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h06);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 4 * 4 = 16 (Result truncated to 0)", test_num);
            reset_dut();
            IOA = 8'h04;
            IOB = 8'h04;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 15 * 15 = 225 (Result truncated to 1)", test_num);
            reset_dut();
            IOA = 8'h0F;
            IOB = 8'h0F;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Ignore upper bits (0xF2 * 0xA3 = 6)", test_num);
            reset_dut();
            IOA = 8'hF2;
            IOB = 8'hA3;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h06);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiply by zero (15 * 0 = 0)", test_num);
            reset_dut();
            IOA = 8'h0F;
            IOB = 8'h00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_IOE;
        begin
            if (expected_IOE === (expected_IOE ^ IOE ^ expected_IOE)) begin
                $display("PASS");
                $display("  Outputs: IOE=%h",
                         IOE);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IOE=%h",
                         expected_IOE);
                $display("  Got:      IOE=%h",
                         IOE);
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
        $dumpvars(0,IOA, IOB, clk, reset, IOE);
    end

endmodule
