`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] imag_a;
    reg [31:0] imag_b;
    reg [31:0] real_a;
    reg [31:0] real_b;
    reg rst;
    reg valid;
    wire [31:0] imag_out;
    wire [31:0] real_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .imag_a(imag_a),
        .imag_b(imag_b),
        .real_a(real_a),
        .real_b(real_b),
        .rst(rst),
        .valid(valid),
        .imag_out(imag_out),
        .real_out(real_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            valid = 0;
            real_a = 0;
            imag_a = 0;
            real_b = 0;
            imag_b = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Simple Positive Addition", test_num);
            reset_dut();

            real_a = 32'd100;
            imag_a = 32'd200;
            real_b = 32'd50;
            imag_b = 32'd150;
            valid = 1;

            @(posedge clk);
            #1;
            valid = 0;

            #1;


            check_outputs(32'd350, 32'd150);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Negative Integer Addition", test_num);
            reset_dut();

            real_a = -32'sd500;
            imag_a = 32'sd1000;
            real_b = 32'sd200;
            imag_b = -32'sd1500;
            valid = 1;

            @(posedge clk);
            #1;
            valid = 0;



            #1;




            check_outputs(-32'sd500, -32'sd300);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Zero Result Addition", test_num);
            reset_dut();

            real_a = 32'sd123456;
            imag_a = -32'sd654321;
            real_b = -32'sd123456;
            imag_b = 32'sd654321;
            valid = 1;

            @(posedge clk);
            #1;
            valid = 0;

            #1;


            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Large Value Addition", test_num);
            reset_dut();

            real_a = 32'h10000000;
            imag_a = 32'h20000000;
            real_b = 32'h05000000;
            imag_b = 32'h05000000;
            valid = 1;

            @(posedge clk);
            #1;
            valid = 0;

            #1;


            check_outputs(32'h25000000, 32'h15000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Valid Signal Gating Check", test_num);
            reset_dut();


            real_a = 32'd10; imag_a = 32'd10;
            real_b = 32'd10; imag_b = 32'd10;
            valid = 1;
            @(posedge clk);
            #1;


            real_a = 32'd50; imag_a = 32'd50;
            valid = 0;
            @(posedge clk);
            #1;



            #1;




            check_outputs(32'd20, 32'd20);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Max Signed Boundary", test_num);
            reset_dut();

            real_a = 32'h3FFFFFFF;
            imag_a = 32'h3FFFFFFF;
            real_b = 32'h00000001;
            imag_b = 32'h00000001;
            valid = 1;

            @(posedge clk);
            #1;
            valid = 0;

            #1;


            check_outputs(32'h40000000, 32'h40000000);
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
        input [31:0] expected_imag_out;
        input [31:0] expected_real_out;
        begin
            if (expected_imag_out === (expected_imag_out ^ imag_out ^ expected_imag_out) &&
                expected_real_out === (expected_real_out ^ real_out ^ expected_real_out)) begin
                $display("PASS");
                $display("  Outputs: imag_out=%h, real_out=%h",
                         imag_out, real_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: imag_out=%h, real_out=%h",
                         expected_imag_out, expected_real_out);
                $display("  Got:      imag_out=%h, real_out=%h",
                         imag_out, real_out);
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
        $dumpvars(0,clk, imag_a, imag_b, real_a, real_b, rst, valid, imag_out, real_out);
    end

endmodule
