`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg [1:0] op;
    reg rst_n;
    wire [31:0] data_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .op(op),
        .rst_n(rst_n),
        .data_out(data_out),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            data_in = 0;
            op = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Addition");
            reset_dut();
            op = ADD; data_in = 32'sd100;
            @(posedge clk); #1;
            op = ADD; data_in = 32'sd250;
            @(posedge clk); #1;
            #1;

            check_outputs(32'sd350, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Basic Subtraction");
            reset_dut();
            op = SUB; data_in = 32'sd50;
            @(posedge clk); #1;
            op = SUB; data_in = 32'sd25;
            @(posedge clk); #1;
            #1;

            check_outputs(-32'sd75, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Basic Multiplication");
            reset_dut();
            op = ADD; data_in = 32'sd12;
            @(posedge clk); #1;
            op = MUL; data_in = 32'sd5;
            @(posedge clk); #1;
            #1;

            check_outputs(32'sd60, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Basic Division");
            reset_dut();
            op = ADD; data_in = 32'sd100;
            @(posedge clk); #1;
            op = DIV; data_in = 32'sd4;
            @(posedge clk); #1;
            #1;

            check_outputs(32'sd25, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Division by Zero");
            reset_dut();
            op = ADD; data_in = 32'sd50;
            @(posedge clk); #1;
            op = DIV; data_in = 32'sd0;
            @(posedge clk); #1;


            #1;



            check_outputs(data_out, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Signed Arithmetic");
            reset_dut();
            op = SUB; data_in = 32'sd10;
            @(posedge clk); #1;
            op = MUL; data_in = 32'sd3;
            @(posedge clk); #1;
            #1;

            check_outputs(-32'sd30, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Signed Division");
            reset_dut();
            op = SUB; data_in = 32'sd100;
            @(posedge clk); #1;
            op = DIV; data_in = 32'sd3;
            @(posedge clk); #1;
            #1;

            check_outputs(-32'sd33, 1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Reset state check");
            reset_dut();



            #1;




            check_outputs(32'h0, 1'b0);
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
        input [31:0] expected_data_out;
        input expected_valid;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, valid=%b",
                         data_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, valid=%b",
                         expected_data_out, expected_valid);
                $display("  Got:      data_out=%h, valid=%b",
                         data_out, valid);
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
        $dumpvars(0,clk, data_in, op, rst_n, data_out, valid);
    end

endmodule
