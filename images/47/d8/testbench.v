`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clear;
    reg Frame;
    reg Sclk;
    reg [39:0] Shifted;
    reg p2s_enable;
    wire OutReady;
    wire Serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clear(Clear),
        .Frame(Frame),
        .Sclk(Sclk),
        .Shifted(Shifted),
        .p2s_enable(p2s_enable),
        .OutReady(OutReady),
        .Serial_out(Serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        Sclk = 0;
        forever #5 Sclk = ~Sclk;
    end

        task reset_dut;

        begin
            Clear = 1;
            Frame = 0;
            Shifted = 40'b0;
            p2s_enable = 0;
            repeat(2) @(posedge Sclk);
            Clear = 0;
            repeat(2) @(posedge Sclk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running testcase001: All Zeros...");
            reset_dut();

            Shifted = 40'h0000000000;
            p2s_enable = 1;
            @(posedge Sclk);
            p2s_enable = 0;

            Frame = 1;

            repeat(40) @(negedge Sclk);
            Frame = 0;


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running testcase002: All Ones...");
            reset_dut();

            Shifted = 40'hFFFFFFFFFF;
            p2s_enable = 1;
            @(posedge Sclk);
            p2s_enable = 0;

            Frame = 1;

            repeat(40) @(negedge Sclk);
            Frame = 0;


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running testcase003: Alternating pattern 0xA5...");
            reset_dut();

            Shifted = 40'hA5A5A5A5A5;
            p2s_enable = 1;
            @(posedge Sclk);
            p2s_enable = 0;

            Frame = 1;


            repeat(40) @(negedge Sclk);
            Frame = 0;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running testcase004: Pattern 0x123456789A...");
            reset_dut();

            Shifted = 40'h123456789A;
            p2s_enable = 1;
            @(posedge Sclk);
            p2s_enable = 0;

            Frame = 1;

            repeat(40) @(negedge Sclk);
            Frame = 0;

            #1;


            check_outputs(1'b0, 1'b0);
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
        input expected_OutReady;
        input expected_Serial_out;
        begin
            if (expected_OutReady === (expected_OutReady ^ OutReady ^ expected_OutReady) &&
                expected_Serial_out === (expected_Serial_out ^ Serial_out ^ expected_Serial_out)) begin
                $display("PASS");
                $display("  Outputs: OutReady=%b, Serial_out=%b",
                         OutReady, Serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OutReady=%b, Serial_out=%b",
                         expected_OutReady, expected_Serial_out);
                $display("  Got:      OutReady=%b, Serial_out=%b",
                         OutReady, Serial_out);
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
        $dumpvars(0,Clear, Frame, Sclk, Shifted, p2s_enable, OutReady, Serial_out);
    end

endmodule
