`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg clk;
    reg [3:0] data_in;
    reg load;
    reg reset;
    wire [15:0] Y;
    wire [3:0] count;
    wire [3:0] final_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .reset(reset),
        .Y(Y),
        .count(count),
        .final_output(final_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            data_in = 0;
            A = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Reset logic");
            reset_dut();
            A = 4'h0;
            @(posedge clk);



            #1;




            check_outputs(16'hFFFE, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Load logic");
            reset_dut();
            data_in = 4'hA;
            load = 1;
            A = 4'h5;
            @(posedge clk);
            #1 load = 0;



            #1;




            check_outputs(16'hFFDF, 4'hA, 4'hF);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Simple counting");
            reset_dut();
            A = 4'h2;

            repeat(3) @(posedge clk);



            #1;




            check_outputs(16'hFFFB, 4'h3, 4'h5);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Counter wrap-around");
            reset_dut();
            data_in = 4'hF;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            A = 4'h1;
            @(posedge clk);



            #1;




            check_outputs(16'hFFFD, 4'h0, 4'h1);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Adder wrapping");
            reset_dut();
            data_in = 4'hE;
            load = 1;
            A = 4'h4;
            @(posedge clk);
            #1 load = 0;



            #1;




            check_outputs(16'hFFEF, 4'hE, 4'h2);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Decoder high-end check");
            reset_dut();
            A = 4'hF;
            @(posedge clk);



            #1;




            check_outputs(16'h7FFF, 4'h1, 4'h0);
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
        input [15:0] expected_Y;
        input [3:0] expected_count;
        input [3:0] expected_final_output;
        begin
            if (expected_Y === (expected_Y ^ Y ^ expected_Y) &&
                expected_count === (expected_count ^ count ^ expected_count) &&
                expected_final_output === (expected_final_output ^ final_output ^ expected_final_output)) begin
                $display("PASS");
                $display("  Outputs: Y=%h, count=%h, final_output=%h",
                         Y, count, final_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h, count=%h, final_output=%h",
                         expected_Y, expected_count, expected_final_output);
                $display("  Got:      Y=%h, count=%h, final_output=%h",
                         Y, count, final_output);
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
        $dumpvars(0,A, clk, data_in, load, reset, Y, count, final_output);
    end

endmodule
