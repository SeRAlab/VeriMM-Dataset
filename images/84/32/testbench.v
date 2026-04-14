`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg enable;
    reg [31:0] left;
    reg [31:0] right;
    wire result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .enable(enable),
        .left(left),
        .right(right),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            enable <= 1'b1;
            left <= 32'h0;
            right <= 32'h0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Basic Equality", test_num);
            left <= 32'hA5A5_5A5A;
            right <= 32'hA5A5_5A5A;
            enable <= 1'b1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Basic Inequality", test_num);
            left <= 32'hFFFF_FFFF;
            right <= 32'hFFFF_FFFE;
            enable <= 1'b1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();

            $display("Testcase %0d: Enable Low (Result should hold 1)", test_num);
            left <= 32'h1234_5678;
            right <= 32'h8765_4321;
            enable <= 1'b0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();

            left <= 32'h1; right <= 32'h0; enable <= 1'b1;
            @(posedge clock);
            #1;

            $display("Testcase %0d: Enable Low (Result should hold 0)", test_num);
            left <= 32'hAAAA_BBBB;
            right <= 32'hAAAA_BBBB;
            enable <= 1'b0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: First Nibble Mismatch", test_num);
            left <=  32'h0000_000F;
            right <= 32'h0000_000E;
            enable <= 1'b1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Last Nibble Mismatch", test_num);
            left <=  32'hF000_0000;
            right <= 32'hE000_0000;
            enable <= 1'b1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Middle Nibble Mismatch", test_num);
            left <=  32'h000F_0000;
            right <= 32'h000E_0000;
            enable <= 1'b1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: All Bits Set Equality", test_num);
            left <=  32'hFFFF_FFFF;
            right <= 32'hFFFF_FFFF;
            enable <= 1'b1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1);
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
        input expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%b",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%b",
                         expected_result);
                $display("  Got:      result=%b",
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
        $dumpvars(0,clock, enable, left, right, result);
    end

endmodule
