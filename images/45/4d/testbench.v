`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in_signal;
    reg [254:0] in_vector;
    reg reset;
    wire [7:0] bit_count;
    wire [7:0] edge_count;
    wire [7:0] output_sum;

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
        .output_sum(output_sum)
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
        test_num = test_num + 1;
        $display("Testcase %0d: Reset State Check", test_num);
        reset_dut();

        #1;


        check_outputs(8'd0, 8'd0, 8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Vector Population Count", test_num);
        reset_dut();

        in_vector = 0;
        in_vector[0] = 1;
        in_vector[1] = 1;
        in_vector[2] = 1;
        in_vector[10] = 1;
        in_vector[20] = 1;
        in_vector[100] = 1;
        in_vector[254] = 1;

        @(posedge clk);
        #1;

        #1;


        check_outputs(8'd7, 8'd0, 8'd7);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Rising Edge Count", test_num);
        reset_dut();


        in_signal = 8'h00;
        @(posedge clk);
        #1;
        in_signal = 8'hFF;
        @(posedge clk);
        #1;


        #1;



        check_outputs(8'd0, 8'd8, 8'd8);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Cumulative Edge Count", test_num);
        reset_dut();


        in_signal = 8'h01;
        @(posedge clk);
        #1;

        in_signal = 8'h03;
        @(posedge clk);
        #1;

        in_signal = 8'h00;
        @(posedge clk);
        #1;

        in_signal = 8'hAA;
        @(posedge clk);
        #1;


        #1;



        check_outputs(8'd0, 8'd6, 8'd6);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Combined Max Popcount and Transitions", test_num);
        reset_dut();


        in_vector = {255{1'b1}};


        in_signal = 8'h00;
        @(posedge clk);
        #1;
        in_signal = 8'h0F;
        @(posedge clk);
        #1;

        in_signal = 8'hF0;
        @(posedge clk);
        #1;




        #1;





        check_outputs(8'hFF, 8'h08, 8'h07);
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
        input [7:0] expected_bit_count;
        input [7:0] expected_edge_count;
        input [7:0] expected_output_sum;
        begin
            if (expected_bit_count === (expected_bit_count ^ bit_count ^ expected_bit_count) &&
                expected_edge_count === (expected_edge_count ^ edge_count ^ expected_edge_count) &&
                expected_output_sum === (expected_output_sum ^ output_sum ^ expected_output_sum)) begin
                $display("PASS");
                $display("  Outputs: bit_count=%h, edge_count=%h, output_sum=%h",
                         bit_count, edge_count, output_sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bit_count=%h, edge_count=%h, output_sum=%h",
                         expected_bit_count, expected_edge_count, expected_output_sum);
                $display("  Got:      bit_count=%h, edge_count=%h, output_sum=%h",
                         bit_count, edge_count, output_sum);
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
        $dumpvars(0,clk, in_signal, in_vector, reset, bit_count, edge_count, output_sum);
    end

endmodule
