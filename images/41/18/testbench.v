`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ck;
    reg [3:0] code;
    reg reset_n;
    wire [1:0] pattern;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ck(ck),
        .code(code),
        .reset_n(reset_n),
        .pattern(pattern)
    );

    // Clock generation (10ns period)
    initial begin
        ck = 0;
        forever #5 ck = ~ck;
    end

        task reset_dut;

        begin
            reset_n = 0;
            code = 4'b0;
            repeat(2) @(posedge ck);
            #1;
            reset_n = 1;
            repeat(1) @(posedge ck);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4'h0", test_num);
            reset_dut();
            code = 4'h0;
            @(posedge ck);
            #1;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4'h5", test_num);
            reset_dut();
            code = 4'h5;
            @(posedge ck);
            #1;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4'hA", test_num);
            reset_dut();
            code = 4'hA;
            @(posedge ck);
            #1;

            #1;


            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4'hF", test_num);
            reset_dut();
            code = 4'hF;
            @(posedge ck);
            #1;

            #1;


            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4'h3", test_num);
            reset_dut();
            code = 4'h3;
            @(posedge ck);
            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4'h8", test_num);
            reset_dut();
            code = 4'h8;
            @(posedge ck);
            #1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4'hC", test_num);
            reset_dut();
            code = 4'hC;
            @(posedge ck);
            #1;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4'h7", test_num);
            reset_dut();
            code = 4'h7;
            @(posedge ck);
            #1;
            #1;

            check_outputs(2'b01);
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
        input [1:0] expected_pattern;
        begin
            if (expected_pattern === (expected_pattern ^ pattern ^ expected_pattern)) begin
                $display("PASS");
                $display("  Outputs: pattern=%h",
                         pattern);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pattern=%h",
                         expected_pattern);
                $display("  Got:      pattern=%h",
                         pattern);
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
        $dumpvars(0,ck, code, reset_n, pattern);
    end

endmodule
