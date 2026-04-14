`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg freq;
    reg in;
    reg rst;
    wire [1:0] out;
    wire out_waveform;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .freq(freq),
        .in(in),
        .rst(rst),
        .out(out),
        .out_waveform(out_waveform)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: System Reset State", test_num);

        rst = 1;
        in = 0;
        freq = 0;
        #100;
        rst = 0;
        #20;


        #1;



        check_outputs(2'b00, 1'b0);
    end
        endtask

    task testcase002;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Tone A (Low Freq) Detection", test_num);

        rst = 1;
        #20 rst = 0;
        freq = 0;


        for (i = 0; i < 100; i = i + 1) begin
            #20 in = ~in;
        end


        #100;


        #1;



        check_outputs(2'b01, 1'b1);
    end
        endtask

    task testcase003;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Tone B (High Freq) Detection", test_num);

        rst = 1;
        in = 0;
        #20 rst = 0;
        freq = 1;


        for (i = 0; i < 200; i = i + 1) begin
            #10 in = ~in;
        end

        #100;


        #1;



        check_outputs(2'b10, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Static Input (No Detection)", test_num);

        rst = 1;
        in = 1;
        #20 rst = 0;
        freq = 0;


        #2000;

        #1;


        check_outputs(2'b00, 1'b0);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Out-of-Band Noise Filtering", test_num);

        rst = 1;
        in = 0;
        #20 rst = 0;
        freq = 1;


        for (i = 0; i < 500; i = i + 1) begin
            #5 in = ~in;
        end

        #100;

        #1;


        check_outputs(2'b00, 1'b0);
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
        input [1:0] expected_out;
        input expected_out_waveform;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_out_waveform === (expected_out_waveform ^ out_waveform ^ expected_out_waveform)) begin
                $display("PASS");
                $display("  Outputs: out=%h, out_waveform=%b",
                         out, out_waveform);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, out_waveform=%b",
                         expected_out, expected_out_waveform);
                $display("  Got:      out=%h, out_waveform=%b",
                         out, out_waveform);
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

endmodule
