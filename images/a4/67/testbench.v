`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg reset;
    reg shift;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .reset(reset),
        .shift(shift),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            shift = 0;
            d = 0;
            #10;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load data (shift=0)", test_num);
            reset_dut();

            d = 8'hA5;
            shift = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single right shift", test_num);
            reset_dut();


            d = 8'hFF;
            shift = 0;
            @(posedge clk);


            shift = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h7F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple shifts (Zero-fill check)", test_num);
            reset_dut();


            d = 8'h80;
            shift = 0;
            @(posedge clk);


            shift = 1;
            repeat(4) @(posedge clk);
            #1;


            #1;



            check_outputs(8'h08);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift until empty", test_num);
            reset_dut();

            d = 8'h01;
            shift = 0;
            @(posedge clk);

            shift = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Asynchronous reset mid-cycle", test_num);
            reset_dut();

            d = 8'hFF;
            shift = 0;
            @(posedge clk);
            #1;


            reset = 1;
            #2;
            #1;

            check_outputs(8'h00);
            reset = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating load and shift", test_num);
            reset_dut();


            d = 8'hAA;
            shift = 0;
            @(posedge clk);


            shift = 1;
            @(posedge clk);


            d = 8'hBE;
            shift = 0;
            @(posedge clk);


            shift = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h5F);
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, d, reset, shift, q);
    end

endmodule
