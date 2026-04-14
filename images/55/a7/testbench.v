`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg [15:0] x;
    wire [6:0] a_to_g;
    wire [3:0] an;
    wire dp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clr(clr),
        .x(x),
        .a_to_g(a_to_g),
        .an(an),
        .dp(dp)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clr = 0;
            x = 16'h0000;
            @(posedge clk);
            #2;
            clr = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            x = 16'hCA30;

            wait(an == 4'b1110);
            #1;

            check_outputs(7'b0000001, 4'b1110, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            x = 16'hCA30;

            wait(an == 4'b1101);
            #1;

            check_outputs(7'b0000110, 4'b1101, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            x = 16'hCA30;
            wait(an == 4'b1011);
            #1;

            check_outputs(7'b0001000, 4'b1011, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            x = 16'hCA30;
            wait(an == 4'b0111);
            #1;

            check_outputs(7'b0110001, 4'b0111, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            x = 16'hB912;
            wait(an == 4'b1101);
            #1;

            check_outputs(7'b0000100, 4'b1101, 1'b1);
            wait(an == 4'b0111);
            #1;

            check_outputs(7'b1100000, 4'b0111, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            x = 16'h1234;
            @(posedge clk);
            clr = 0;
            repeat(2) @(posedge clk);

            if (an == 4'b1111) begin
                $display("PASS: Test %0d | Clear successful (Anodes disabled)", test_num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Test %0d | Clear did not disable anodes", test_num);
                fail_count = fail_count + 1;
            end
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
        input [6:0] expected_a_to_g;
        input [3:0] expected_an;
        input expected_dp;
        begin
            if (expected_a_to_g === (expected_a_to_g ^ a_to_g ^ expected_a_to_g) &&
                expected_an === (expected_an ^ an ^ expected_an) &&
                expected_dp === (expected_dp ^ dp ^ expected_dp)) begin
                $display("PASS");
                $display("  Outputs: a_to_g=%h, an=%h, dp=%b",
                         a_to_g, an, dp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a_to_g=%h, an=%h, dp=%b",
                         expected_a_to_g, expected_an, expected_dp);
                $display("  Got:      a_to_g=%h, an=%h, dp=%b",
                         a_to_g, an, dp);
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
        $dumpvars(0,clk, clr, x, a_to_g, an, dp);
    end

endmodule
