`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [8:0] N;
    reg clock;
    reg reset;
    reg start;
    wire [7:0] counter;
    wire done;
    wire [8:0] dp;
    wire [7:0] sr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .N(N),
        .clock(clock),
        .reset(reset),
        .start(start),
        .counter(counter),
        .done(done),
        .dp(dp),
        .sr(sr)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            N = 0;
            repeat(2) @(posedge clock);
            #1 reset = 0;
            repeat(1) @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small N (N=10)", test_num);
            reset_dut();

            N = 9'd10;
            start = 1;
            @(posedge clock);
            #1 start = 0;


            wait(done === 1);
            @(posedge clock);
            #1;




            #1;





            check_outputs(8'h00, 1'b1, 9'h00A, 8'h0A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Edge Case N=0", test_num);
            reset_dut();

            N = 9'd0;
            start = 1;
            @(posedge clock);
            #1 start = 0;

            wait(done === 1);
            @(posedge clock);
            #1;

            #1;


            check_outputs(8'h00, 1'b1, 9'h000, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum N (N=511)", test_num);
            reset_dut();

            N = 9'h1FF;
            start = 1;
            @(posedge clock);
            #1 start = 0;


            wait(done === 1);
            @(posedge clock);
            #1;

            #1;


            check_outputs(8'h00, 1'b1, 9'h1FF, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Consecutive Operations (N=5 then N=15)", test_num);
            reset_dut();


            N = 9'd5;
            start = 1;
            @(posedge clock);
            #1 start = 0;
            wait(done === 1);


            repeat(3) @(posedge clock);


            N = 9'd15;
            start = 1;
            @(posedge clock);
            #1 start = 0;
            wait(done === 1);
            @(posedge clock);
            #1;

            #1;


            check_outputs(8'h00, 1'b1, 9'h00F, 8'h0F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Mid-Process", test_num);
            reset_dut();

            N = 9'h0FF;
            start = 1;
            @(posedge clock);
            #1 start = 0;


            repeat(5) @(posedge clock);


            reset = 1;
            repeat(2) @(posedge clock);
            reset = 0;


            #1;
            #1;

            check_outputs(8'h00, 1'b0, 9'h000, 8'h00);
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
        input [7:0] expected_counter;
        input expected_done;
        input [8:0] expected_dp;
        input [7:0] expected_sr;
        begin
            if (expected_counter === (expected_counter ^ counter ^ expected_counter) &&
                expected_done === (expected_done ^ done ^ expected_done) &&
                expected_dp === (expected_dp ^ dp ^ expected_dp) &&
                expected_sr === (expected_sr ^ sr ^ expected_sr)) begin
                $display("PASS");
                $display("  Outputs: counter=%h, done=%b, dp=%h, sr=%h",
                         counter, done, dp, sr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter=%h, done=%b, dp=%h, sr=%h",
                         expected_counter, expected_done, expected_dp, expected_sr);
                $display("  Got:      counter=%h, done=%b, dp=%h, sr=%h",
                         counter, done, dp, sr);
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
        $dumpvars(0,N, clock, reset, start, counter, done, dp, sr);
    end

endmodule
