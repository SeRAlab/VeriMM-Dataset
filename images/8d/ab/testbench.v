`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [14:0] ast_sink_data;
    reg [1:0] ast_sink_error;
    reg ast_sink_valid;
    reg ast_source_ready;
    reg clk;
    reg reset_n;
    wire ast_sink_ready;
    wire [30:0] ast_source_data;
    wire [1:0] ast_source_error;
    wire ast_source_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ast_sink_data(ast_sink_data),
        .ast_sink_error(ast_sink_error),
        .ast_sink_valid(ast_sink_valid),
        .ast_source_ready(ast_source_ready),
        .clk(clk),
        .reset_n(reset_n),
        .ast_sink_ready(ast_sink_ready),
        .ast_source_data(ast_source_data),
        .ast_source_error(ast_source_error),
        .ast_source_valid(ast_source_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            ast_sink_data = 0;
            ast_sink_error = 0;
            ast_sink_valid = 0;
            ast_source_ready = 0;
            #20;
            reset_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Data Transfer");
            reset_dut();
            @(posedge clk);
            ast_sink_data = 15'h1234;
            ast_sink_error = 2'b01;
            ast_sink_valid = 1;
            ast_source_ready = 1;

            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 31'h00001234, 2'b01, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Error Flag Propagation");
            reset_dut();
            @(posedge clk);
            ast_sink_data = 15'h7FFF;
            ast_sink_error = 2'b11;
            ast_sink_valid = 1;
            ast_source_ready = 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 31'h00007FFF, 2'b11, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Backpressure (Source Not Ready)");
            reset_dut();
            @(posedge clk);
            ast_sink_data = 15'hAAAA;
            ast_sink_error = 2'b00;
            ast_sink_valid = 1;
            ast_source_ready = 0;

            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 31'h0000AAAA, 2'b00, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Zero Data Transfer");
            reset_dut();
            @(posedge clk);
            ast_sink_data = 15'h0000;
            ast_sink_error = 2'b00;
            ast_sink_valid = 1;
            ast_source_ready = 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 31'h00000000, 2'b00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Idle State (Sink Valid Low)");
            reset_dut();
            @(posedge clk);
            ast_sink_data = 15'h5555;
            ast_sink_error = 2'b10;
            ast_sink_valid = 0;
            ast_source_ready = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 31'h00005555, 2'b10, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Alternating Ready/Valid");
            reset_dut();


            @(posedge clk);
            ast_sink_data = 15'h1111;
            ast_sink_valid = 1;
            ast_source_ready = 0;

            @(posedge clk);
            #1;


            ast_source_ready = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 31'h00001111, 2'b00, 1'b1);
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
        input expected_ast_sink_ready;
        input [30:0] expected_ast_source_data;
        input [1:0] expected_ast_source_error;
        input expected_ast_source_valid;
        begin
            if (expected_ast_sink_ready === (expected_ast_sink_ready ^ ast_sink_ready ^ expected_ast_sink_ready) &&
                expected_ast_source_data === (expected_ast_source_data ^ ast_source_data ^ expected_ast_source_data) &&
                expected_ast_source_error === (expected_ast_source_error ^ ast_source_error ^ expected_ast_source_error) &&
                expected_ast_source_valid === (expected_ast_source_valid ^ ast_source_valid ^ expected_ast_source_valid)) begin
                $display("PASS");
                $display("  Outputs: ast_sink_ready=%b, ast_source_data=%h, ast_source_error=%h, ast_source_valid=%b",
                         ast_sink_ready, ast_source_data, ast_source_error, ast_source_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ast_sink_ready=%b, ast_source_data=%h, ast_source_error=%h, ast_source_valid=%b",
                         expected_ast_sink_ready, expected_ast_source_data, expected_ast_source_error, expected_ast_source_valid);
                $display("  Got:      ast_sink_ready=%b, ast_source_data=%h, ast_source_error=%h, ast_source_valid=%b",
                         ast_sink_ready, ast_source_data, ast_source_error, ast_source_valid);
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
        $dumpvars(0,ast_sink_data, ast_sink_error, ast_sink_valid, ast_source_ready, clk, reset_n, ast_sink_ready, ast_source_data, ast_source_error, ast_source_valid);
    end

endmodule
