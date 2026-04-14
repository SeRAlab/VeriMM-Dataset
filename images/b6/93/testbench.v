`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [10:0] in;
    reg ld;
    reg shift;
    wire [10:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .ld(ld),
        .shift(shift),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            ld = 1;
            in = 11'h0;
            shift = 0;
            @(posedge clk);
            ld = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load value 11'h5AA", test_num);
            reset_dut();

            @(posedge clk);
            ld = 1;
            in = 11'h5AA;
            shift = 0;

            @(posedge clk);
            ld = 0;
            #1;
            #1;

            check_outputs(11'h5AA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift Right from 11'h400", test_num);
            reset_dut();


            @(posedge clk);
            ld = 1;
            in = 11'h400;
            @(posedge clk);


            ld = 0;
            shift = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(11'h200);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Priority Check (ld=1, shift=1)", test_num);
            reset_dut();


            @(posedge clk);
            ld = 1;
            in = 11'h7FF;
            @(posedge clk);


            ld = 1;
            in = 11'h0F0;
            shift = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(11'h0F0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Hold value", test_num);
            reset_dut();


            @(posedge clk);
            ld = 1;
            in = 11'h123;
            @(posedge clk);


            ld = 0;
            shift = 0;
            in = 11'h7FF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(11'h123);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple shifts to zero", test_num);
            reset_dut();


            @(posedge clk);
            ld = 1;
            in = 11'h001;
            @(posedge clk);


            ld = 0;
            shift = 1;
            @(posedge clk);

            @(posedge clk);
            #1;
            #1;

            check_outputs(11'h000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift MSB to LSB position", test_num);
            reset_dut();


            @(posedge clk);
            ld = 1;
            in = 11'h400;
            @(posedge clk);


            ld = 0;
            shift = 1;
            repeat(10) @(posedge clk);

            #1;
            #1;

            check_outputs(11'h001);
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
        input [10:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, in, ld, shift, out);
    end

endmodule
