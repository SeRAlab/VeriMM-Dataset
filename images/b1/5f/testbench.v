`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dataIn;
    reg enable;
    reg reset;
    wire ready;
    wire [63:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dataIn(dataIn),
        .enable(enable),
        .reset(reset),
        .ready(ready),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            dataIn = 8'h00;
            @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic 8-cycle sequence fill", test_num);
            reset_dut();

            for (i = 1; i <= 8; i = i + 1) begin
                enable = 1;
                dataIn = i;
                @(negedge clk);
            end

            enable = 0;


            #1;



            check_outputs(1'b1, 64'h0807060504030201);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fill with enable de-asserted intermittently", test_num);
            reset_dut();


            for (i = 0; i < 4; i = i + 1) begin
                enable = 1;
                dataIn = 8'hA0 + i;
                @(negedge clk);
            end


            enable = 0;
            repeat(3) @(negedge clk);


            for (i = 4; i < 8; i = i + 1) begin
                enable = 1;
                dataIn = 8'hA0 + i;
                @(negedge clk);
            end

            enable = 0;
            #1;

            check_outputs(1'b1, 64'hA7A6A5A4A3A2A1A0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Back-to-back 64-bit loads", test_num);
            reset_dut();


            for (i = 0; i < 8; i = i + 1) begin
                enable = 1;
                dataIn = 8'hFF;
                @(negedge clk);
            end


            for (i = 0; i < 8; i = i + 1) begin
                enable = 1;
                dataIn = 8'hEE;
                @(negedge clk);
            end

            enable = 0;
            #1;

            check_outputs(1'b1, 64'hEEEEEEEEEEEEEEEE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Filling with all zeros", test_num);
            reset_dut();


            enable = 1;
            dataIn = 8'hFF;
            repeat(4) @(negedge clk);


            reset_dut();

            for (i = 0; i < 8; i = i + 1) begin
                enable = 1;
                dataIn = 8'h00;
                @(negedge clk);
            end

            enable = 0;
            #1;

            check_outputs(1'b1, 64'h0000000000000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset during partial load", test_num);
            reset_dut();


            for (i = 0; i < 4; i = i + 1) begin
                enable = 1;
                dataIn = 8'hCC;
                @(negedge clk);
            end


            reset = 1;
            @(negedge clk);
            reset = 0;


            for (i = 0; i < 8; i = i + 1) begin
                enable = 1;
                dataIn = 8'h55;
                @(negedge clk);
            end

            enable = 0;
            #1;

            check_outputs(1'b1, 64'h5555555555555555);
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
        input expected_ready;
        input [63:0] expected_result;
        begin
            if (expected_ready === (expected_ready ^ ready ^ expected_ready) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: ready=%b, result=%h",
                         ready, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ready=%b, result=%h",
                         expected_ready, expected_result);
                $display("  Got:      ready=%b, result=%h",
                         ready, result);
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
        $dumpvars(0,clk, dataIn, enable, reset, ready, result);
    end

endmodule
