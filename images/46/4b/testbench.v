`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data;
    reg reset;
    wire [3:0] an;
    wire [6:0] sseg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .reset(reset),
        .an(an),
        .sseg(sseg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data = 16'h0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Data 0x1234, Check Digit 0");
            reset_dut();
            data = 16'h1234;


            repeat(1000) begin
                @(posedge clk);
                if (an === 4'b1110) begin
                    #1 #1;
 check_outputs(4'b1110, get_sseg_pattern(4'h4));
                    disable testcase001;
                end
            end
            $display("FAIL: Anode 1110 not reached");
            fail_count = fail_count + 1;
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Data 0x1234, Check Digit 1");
            reset_dut();
            data = 16'h1234;
            repeat(1000) begin
                @(posedge clk);
                if (an === 4'b1101) begin
                    #1 #1;
 check_outputs(4'b1101, get_sseg_pattern(4'h3));
                    disable testcase002;
                end
            end
            $display("FAIL: Anode 1101 not reached");
            fail_count = fail_count + 1;
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Data 0x1234, Check Digit 2");
            reset_dut();
            data = 16'h1234;
            repeat(1000) begin
                @(posedge clk);
                if (an === 4'b1011) begin
                    #1 #1;
 check_outputs(4'b1011, get_sseg_pattern(4'h2));
                    disable testcase003;
                end
            end
            $display("FAIL: Anode 1011 not reached");
            fail_count = fail_count + 1;
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Data 0x1234, Check Digit 3");
            reset_dut();
            data = 16'h1234;
            repeat(1000) begin
                @(posedge clk);
                if (an === 4'b0111) begin
                    #1 #1;
 check_outputs(4'b0111, get_sseg_pattern(4'h1));
                    disable testcase004;
                end
            end
            $display("FAIL: Anode 0111 not reached");
            fail_count = fail_count + 1;
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Data 0xABCD, Check Digit 0 (D)");
            reset_dut();
            data = 16'hABCD;
            repeat(1000) begin
                @(posedge clk);
                if (an === 4'b1110) begin
                    #1 #1;
 check_outputs(4'b1110, get_sseg_pattern(4'hD));
                    disable testcase005;
                end
            end
            $display("FAIL: Anode 1110 not reached");
            fail_count = fail_count + 1;
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Data 0xABCD, Check Digit 3 (A)");
            reset_dut();
            data = 16'hABCD;
            repeat(1000) begin
                @(posedge clk);
                if (an === 4'b0111) begin
                    #1 #1;
 check_outputs(4'b0111, get_sseg_pattern(4'hA));
                    disable testcase006;
                end
            end
            $display("FAIL: Anode 0111 not reached");
            fail_count = fail_count + 1;
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning testcase007: Data 0x8888, Check Digit 0 (8)");
            reset_dut();
            data = 16'h8888;
            repeat(1000) begin
                @(posedge clk);
                if (an === 4'b1110) begin
                    #1 #1;
 check_outputs(4'b1110, get_sseg_pattern(4'h8));
                    disable testcase007;
                end
            end
            $display("FAIL: Anode 1110 not reached");
            fail_count = fail_count + 1;
        end
        endtask

    task testcase008;

        begin
            $display("\nRunning testcase008: Data 0x0000, Check Digit 0 (0)");
            reset_dut();
            data = 16'h0000;
            repeat(1000) begin
                @(posedge clk);
                if (an === 4'b1110) begin
                    #1 #1;
 check_outputs(4'b1110, get_sseg_pattern(4'h0));
                    disable testcase008;
                end
            end
            $display("FAIL: Anode 1110 not reached");
            fail_count = fail_count + 1;
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
        input [3:0] expected_an;
        input [6:0] expected_sseg;
        begin
            if (expected_an === (expected_an ^ an ^ expected_an) &&
                expected_sseg === (expected_sseg ^ sseg ^ expected_sseg)) begin
                $display("PASS");
                $display("  Outputs: an=%h, sseg=%h",
                         an, sseg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: an=%h, sseg=%h",
                         expected_an, expected_sseg);
                $display("  Got:      an=%h, sseg=%h",
                         an, sseg);
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
        $dumpvars(0,clk, data, reset, an, sseg);
    end

endmodule
