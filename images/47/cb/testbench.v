`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] lookup_data;
    reg rst;
    reg [31:0] wcare;
    reg [31:0] wdata;
    reg wena;
    reg wused;
    wire match;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .lookup_data(lookup_data),
        .rst(rst),
        .wcare(wcare),
        .wdata(wdata),
        .wena(wena),
        .wused(wused),
        .match(match)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            wena = 0;
            wused = 0;
            wdata = 32'h0;
            wcare = 32'h0;
            lookup_data = 32'h0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Basic Exact Match");
            reset_dut();
            @(posedge clk);
            wdata = 32'hABCD1234;
            wcare = 32'hFFFFFFFF;
            wused = 1;
            wena = 1;
            @(posedge clk);
            wena = 0;
            lookup_data = 32'hABCD1234;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: No Match (Different Data)");
            reset_dut();
            @(posedge clk);
            wdata = 32'hAAAA_5555;
            wcare = 32'hFFFF_FFFF;
            wused = 1;
            wena = 1;
            @(posedge clk);
            wena = 0;
            lookup_data = 32'hAAAA_0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Partial Match with Don't Care (Masking)");
            reset_dut();
            @(posedge clk);
            wdata = 32'hDEADBEEF;
            wcare = 32'hFFFF0000;
            wused = 1;
            wena = 1;
            @(posedge clk);
            wena = 0;

            lookup_data = 32'hDEAD0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Entry Not Used (wused = 0)");
            reset_dut();
            @(posedge clk);
            wdata = 32'h12345678;
            wcare = 32'hFFFFFFFF;
            wused = 0;
            wena = 1;
            @(posedge clk);
            wena = 0;
            lookup_data = 32'h12345678;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Write Update Persistence");
            reset_dut();

            @(posedge clk);
            wdata = 32'h11111111;
            wcare = 32'hFFFFFFFF;
            wused = 1;
            wena = 1;
            @(posedge clk);

            wdata = 32'h22222222;
            @(posedge clk);
            wena = 0;

            lookup_data = 32'h11111111;
            @(posedge clk);
            #1;
            if (match === 1'b0) begin

                lookup_data = 32'h22222222;
                @(posedge clk);
                #1;
                #1;

                check_outputs(1'b1);
            end else begin
                #1;

                check_outputs(1'b0);
            end
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Bit-level Masking");
            reset_dut();
            @(posedge clk);
            wdata = 32'b10101010_11110000_10101010_11110000;
            wcare = 32'b10000000_00000000_00000000_00000001;
            wused = 1;
            wena = 1;
            @(posedge clk);
            wena = 0;

            lookup_data = 32'b10001111_01010101_11001100_00001110;
            @(posedge clk);
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
        $dumpvars(0,clk, lookup_data, rst, wcare, wdata, wena, wused, match);
    end

endmodule
