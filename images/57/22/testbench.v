`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clk_ena;
    reg in_stream;
    reg reset;
    wire pipeline_reg_0;
    wire pipeline_reg_1;
    wire pipeline_reg_2;
    wire pipeline_reg_3;
    wire pipeline_reg_4;
    wire pipeline_reg_5;
    wire pipeline_reg_6;
    wire pipeline_reg_7;
    wire pipeline_reg_8;
    wire pipeline_reg_9;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clk_ena(clk_ena),
        .in_stream(in_stream),
        .reset(reset),
        .pipeline_reg_0(pipeline_reg_0),
        .pipeline_reg_1(pipeline_reg_1),
        .pipeline_reg_2(pipeline_reg_2),
        .pipeline_reg_3(pipeline_reg_3),
        .pipeline_reg_4(pipeline_reg_4),
        .pipeline_reg_5(pipeline_reg_5),
        .pipeline_reg_6(pipeline_reg_6),
        .pipeline_reg_7(pipeline_reg_7),
        .pipeline_reg_8(pipeline_reg_8),
        .pipeline_reg_9(pipeline_reg_9)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            clk_ena = 0;
            in_stream = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task feed_bit;

        input bit_val;
        begin
            in_stream = bit_val;
            @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            $display("Testcase 001: Single bit propagation...");
            reset_dut();
            clk_ena = 1;


            feed_bit(1);
            repeat(9) feed_bit(0);


            #1;



            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Pattern fill...");
            reset_dut();
            clk_ena = 1;



            feed_bit(1);
            feed_bit(0);
            feed_bit(1);
            feed_bit(1);
            feed_bit(0);
            feed_bit(0);
            feed_bit(1);
            feed_bit(1);
            feed_bit(1);
            feed_bit(0);


            #1;



            check_outputs(0, 1, 1, 1, 0, 0, 1, 1, 0, 1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Clock Enable gating...");
            reset_dut();


            clk_ena = 1;
            feed_bit(1);


            clk_ena = 0;
            feed_bit(0);
            feed_bit(0);
            feed_bit(0);


            #1;



            check_outputs(1, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Resume operation after clock disable...");
            reset_dut();

            clk_ena = 1;
            feed_bit(1);

            clk_ena = 0;
            repeat(5) feed_bit(0);

            clk_ena = 1;
            repeat(9) feed_bit(0);


            #1;



            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Asynchronous/Synchronous Reset during flow...");
            reset_dut();

            clk_ena = 1;
            repeat(5) feed_bit(1);


            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;


            #1;



            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: All high state...");
            reset_dut();
            clk_ena = 1;
            repeat(10) feed_bit(1);

            #1;


            check_outputs(1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
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
        input expected_pipeline_reg_0;
        input expected_pipeline_reg_1;
        input expected_pipeline_reg_2;
        input expected_pipeline_reg_3;
        input expected_pipeline_reg_4;
        input expected_pipeline_reg_5;
        input expected_pipeline_reg_6;
        input expected_pipeline_reg_7;
        input expected_pipeline_reg_8;
        input expected_pipeline_reg_9;
        begin
            if (expected_pipeline_reg_0 === (expected_pipeline_reg_0 ^ pipeline_reg_0 ^ expected_pipeline_reg_0) &&
                expected_pipeline_reg_1 === (expected_pipeline_reg_1 ^ pipeline_reg_1 ^ expected_pipeline_reg_1) &&
                expected_pipeline_reg_2 === (expected_pipeline_reg_2 ^ pipeline_reg_2 ^ expected_pipeline_reg_2) &&
                expected_pipeline_reg_3 === (expected_pipeline_reg_3 ^ pipeline_reg_3 ^ expected_pipeline_reg_3) &&
                expected_pipeline_reg_4 === (expected_pipeline_reg_4 ^ pipeline_reg_4 ^ expected_pipeline_reg_4) &&
                expected_pipeline_reg_5 === (expected_pipeline_reg_5 ^ pipeline_reg_5 ^ expected_pipeline_reg_5) &&
                expected_pipeline_reg_6 === (expected_pipeline_reg_6 ^ pipeline_reg_6 ^ expected_pipeline_reg_6) &&
                expected_pipeline_reg_7 === (expected_pipeline_reg_7 ^ pipeline_reg_7 ^ expected_pipeline_reg_7) &&
                expected_pipeline_reg_8 === (expected_pipeline_reg_8 ^ pipeline_reg_8 ^ expected_pipeline_reg_8) &&
                expected_pipeline_reg_9 === (expected_pipeline_reg_9 ^ pipeline_reg_9 ^ expected_pipeline_reg_9)) begin
                $display("PASS");
                $display("  Outputs: pipeline_reg_0=%b, pipeline_reg_1=%b, pipeline_reg_2=%b, pipeline_reg_3=%b, pipeline_reg_4=%b, pipeline_reg_5=%b, pipeline_reg_6=%b, pipeline_reg_7=%b, pipeline_reg_8=%b, pipeline_reg_9=%b",
                         pipeline_reg_0, pipeline_reg_1, pipeline_reg_2, pipeline_reg_3, pipeline_reg_4, pipeline_reg_5, pipeline_reg_6, pipeline_reg_7, pipeline_reg_8, pipeline_reg_9);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pipeline_reg_0=%b, pipeline_reg_1=%b, pipeline_reg_2=%b, pipeline_reg_3=%b, pipeline_reg_4=%b, pipeline_reg_5=%b, pipeline_reg_6=%b, pipeline_reg_7=%b, pipeline_reg_8=%b, pipeline_reg_9=%b",
                         expected_pipeline_reg_0, expected_pipeline_reg_1, expected_pipeline_reg_2, expected_pipeline_reg_3, expected_pipeline_reg_4, expected_pipeline_reg_5, expected_pipeline_reg_6, expected_pipeline_reg_7, expected_pipeline_reg_8, expected_pipeline_reg_9);
                $display("  Got:      pipeline_reg_0=%b, pipeline_reg_1=%b, pipeline_reg_2=%b, pipeline_reg_3=%b, pipeline_reg_4=%b, pipeline_reg_5=%b, pipeline_reg_6=%b, pipeline_reg_7=%b, pipeline_reg_8=%b, pipeline_reg_9=%b",
                         pipeline_reg_0, pipeline_reg_1, pipeline_reg_2, pipeline_reg_3, pipeline_reg_4, pipeline_reg_5, pipeline_reg_6, pipeline_reg_7, pipeline_reg_8, pipeline_reg_9);
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
        $dumpvars(0,clk, clk_ena, in_stream, reset, pipeline_reg_0, pipeline_reg_1, pipeline_reg_2, pipeline_reg_3, pipeline_reg_4, pipeline_reg_5, pipeline_reg_6, pipeline_reg_7, pipeline_reg_8, pipeline_reg_9);
    end

endmodule
