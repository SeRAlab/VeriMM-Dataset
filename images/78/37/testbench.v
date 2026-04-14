`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk2;
    reg Reset;
    reg offsetInc;
    wire [3:0] offset;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk2(Clk2),
        .Reset(Reset),
        .offsetInc(offsetInc),
        .offset(offset)
    );

    // Clock generation (10ns period)
    initial begin
        Clk2 = 0;
        forever #5 Clk2 = ~Clk2;
    end

        task reset_dut;

        begin
            Reset = 1;
            offsetInc = 0;
            @(posedge Clk2);
            #1;
            Reset = 0;
            @(posedge Clk2);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %03d: Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %03d: Single Increment", test_num);
            reset_dut();
            offsetInc = 1;
            @(posedge Clk2);
            #1;
            offsetInc = 0;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %03d: Multiple Increments (5 counts)", test_num);
            reset_dut();
            repeat(5) begin
                offsetInc = 1;
                @(posedge Clk2);
                #1;
            end
            offsetInc = 0;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %03d: Counter Overflow (16 increments)", test_num);
            reset_dut();
            repeat(16) begin
                offsetInc = 1;
                @(posedge Clk2);
                #1;
            end
            offsetInc = 0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %03d: Hold Value (increment then disable)", test_num);
            reset_dut();

            repeat(3) begin
                offsetInc = 1;
                @(posedge Clk2);
                #1;
            end

            offsetInc = 0;
            repeat(4) @(posedge Clk2);
            #1;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %03d: Reset during operation", test_num);
            reset_dut();

            repeat(7) begin
                offsetInc = 1;
                @(posedge Clk2);
                #1;
            end

            Reset = 1;
            @(posedge Clk2);
            #1;
            Reset = 0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %03d: Increment to Maximum (15)", test_num);
            reset_dut();
            repeat(15) begin
                offsetInc = 1;
                @(posedge Clk2);
                #1;
            end
            offsetInc = 0;
            #1;

            check_outputs(4'hF);
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
        input [3:0] expected_offset;
        begin
            if (expected_offset === (expected_offset ^ offset ^ expected_offset)) begin
                $display("PASS");
                $display("  Outputs: offset=%h",
                         offset);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: offset=%h",
                         expected_offset);
                $display("  Got:      offset=%h",
                         offset);
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
        $dumpvars(0,Clk2, Reset, offsetInc, offset);
    end

endmodule
