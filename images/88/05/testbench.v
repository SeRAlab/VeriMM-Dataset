`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [63:0] data;
    reg [63:0] key;
    wire match;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .data(data),
        .key(key),
        .match(match)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            data = 64'h0;
            key = 64'h0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros Match", test_num);
            reset_dut();
            data = 64'h0;
            key = 64'h0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones Match", test_num);
            reset_dut();
            data = 64'hFFFFFFFFFFFFFFFF;
            key = 64'hFFFFFFFFFFFFFFFF;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Mismatch", test_num);
            reset_dut();
            data = 64'hAAAAAAAAAAAAAAAA;
            key = 64'h5555555555555555;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: One Bit Difference (LSB)", test_num);
            reset_dut();
            data = 64'hFEEDFACECAFEBEE0;
            key  = 64'hFEEDFACECAFEBEE1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: One Bit Difference (MSB)", test_num);
            reset_dut();
            data = 64'h8000000000000000;
            key  = 64'h0000000000000000;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random Pattern Match", test_num);
            reset_dut();
            data = 64'h1234567890ABCDEF;
            key  = 64'h1234567890ABCDEF;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Toggle Mismatch to Match", test_num);
            reset_dut();

            data = 64'hDEADBEEF;
            key  = 64'hCAFEBABE;
            @(posedge clock);
            #1;

            data = 64'hCAFEBABE;
            key  = 64'hCAFEBABE;
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
        input expected_match;
        begin
            if (expected_match === (expected_match ^ match ^ expected_match)) begin
                $display("PASS");
                $display("  Outputs: match=%b",
                         match);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: match=%b",
                         expected_match);
                $display("  Got:      match=%b",
                         match);
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
        $dumpvars(0,clock, data, key, match);
    end

endmodule
