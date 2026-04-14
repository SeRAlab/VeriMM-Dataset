`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in_signal;
    reg [254:0] in_vector;
    reg reset;
    wire [7:0] bit_count;
    wire [7:0] edge_count;
    wire [7:0] output_diff;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_signal(in_signal),
        .in_vector(in_vector),
        .reset(reset),
        .bit_count(bit_count),
        .edge_count(edge_count),
        .output_diff(output_diff)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in_signal = 0;
            in_vector = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset State Verification", test_num);
            reset_dut();


            #1;



            check_outputs(8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Single Rising Edge Detection", test_num);
            reset_dut();


            in_signal = 8'h01;
            in_vector = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h00, 8'h01, 8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Vector Bit Counting", test_num);
            reset_dut();


            in_signal = 8'h00;
            in_vector = 255'h7;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h03, 8'h00, 8'hFD);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Multi-cycle Accumulation", test_num);
            reset_dut();


            in_signal = 8'h03;
            in_vector = 255'h1;
            @(posedge clk);
            #1;


            in_signal = 8'h07;
            in_vector = 255'h3;
            @(posedge clk);
            #1;


            in_signal = 8'h07;
            in_vector = 255'h8;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h04, 8'h03, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Large Vector Popcount and Signal Toggle", test_num);
            reset_dut();


            in_signal = 8'hFF;
            in_vector = 255'h3FF;
            @(posedge clk);
            #1;


            in_signal = 8'h00;
            in_vector = 255'h1F;
            @(posedge clk);
            #1;


            in_signal = 8'hFF;
            in_vector = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h0F, 8'h10, 8'h01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: 8-bit Overflow Test", test_num);
            reset_dut();



            in_vector = {255{1'b1}};
            in_signal = 0;
            @(posedge clk);
            #1;

            @(posedge clk);
            #1;


            in_signal = 8'hAA;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hFD, 8'h04, 8'h07);
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
        input [7:0] expected_bit_count;
        input [7:0] expected_edge_count;
        input [7:0] expected_output_diff;
        begin
            if (expected_bit_count === (expected_bit_count ^ bit_count ^ expected_bit_count) &&
                expected_edge_count === (expected_edge_count ^ edge_count ^ expected_edge_count) &&
                expected_output_diff === (expected_output_diff ^ output_diff ^ expected_output_diff)) begin
                $display("PASS");
                $display("  Outputs: bit_count=%h, edge_count=%h, output_diff=%h",
                         bit_count, edge_count, output_diff);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bit_count=%h, edge_count=%h, output_diff=%h",
                         expected_bit_count, expected_edge_count, expected_output_diff);
                $display("  Got:      bit_count=%h, edge_count=%h, output_diff=%h",
                         bit_count, edge_count, output_diff);
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
        $dumpvars(0,clk, in_signal, in_vector, reset, bit_count, edge_count, output_diff);
    end

endmodule
