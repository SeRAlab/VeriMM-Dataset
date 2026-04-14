`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] in_data;
    reg load_data;
    reg reset;
    wire [31:0] parallel_out;
    wire [31:0] shift_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_data(in_data),
        .load_data(load_data),
        .reset(reset),
        .parallel_out(parallel_out),
        .shift_out(shift_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load_data = 0;
            in_data = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Reset", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load Data 0xAAAAAAAA", test_num);
            reset_dut();
            in_data = 32'hAAAAAAAA;
            load_data = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'hAAAAAAAA, 32'hAAAAAAAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift Left (1 bit)", test_num);
            reset_dut();
            in_data = 32'h00000001;
            load_data = 1;
            @(posedge clk);
            #1;
            load_data = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00000002, 32'h00000002);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: MSB Wrap Around", test_num);
            reset_dut();
            in_data = 32'h80000000;
            load_data = 1;
            @(posedge clk);
            #1;
            load_data = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00000001, 32'h00000001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiple Shifts", test_num);
            reset_dut();
            in_data = 32'h0000000F;
            load_data = 1;
            @(posedge clk);
            #1;
            load_data = 0;
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(32'h000000F0, 32'h000000F0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset during Shifting", test_num);
            reset_dut();
            in_data = 32'hFFFFFFFF;
            load_data = 1;
            @(posedge clk);
            #1;
            load_data = 0;
            repeat(2) @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Complex Pattern Wrap", test_num);
            reset_dut();
            in_data = 32'hCAFEFACE;
            load_data = 1;
            @(posedge clk);
            #1;
            load_data = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h95FDF59D, 32'h95FDF59D);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Full 32-bit Rotation", test_num);
            reset_dut();
            in_data = 32'h12345678;
            load_data = 1;
            @(posedge clk);
            #1;
            load_data = 0;
            repeat(32) @(posedge clk);
            #1;

            #1;


            check_outputs(32'h12345678, 32'h12345678);
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
        input [31:0] expected_parallel_out;
        input [31:0] expected_shift_out;
        begin
            if (expected_parallel_out === (expected_parallel_out ^ parallel_out ^ expected_parallel_out) &&
                expected_shift_out === (expected_shift_out ^ shift_out ^ expected_shift_out)) begin
                $display("PASS");
                $display("  Outputs: parallel_out=%h, shift_out=%h",
                         parallel_out, shift_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parallel_out=%h, shift_out=%h",
                         expected_parallel_out, expected_shift_out);
                $display("  Got:      parallel_out=%h, shift_out=%h",
                         parallel_out, shift_out);
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
        $dumpvars(0,clk, in_data, load_data, reset, parallel_out, shift_out);
    end

endmodule
