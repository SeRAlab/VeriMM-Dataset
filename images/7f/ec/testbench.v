`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg clk;
    reg [1:0] control;
    reg reset_n;
    reg start;
    wire [31:0] C;
    wire error;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .control(control),
        .reset_n(reset_n),
        .start(start),
        .C(C),
        .error(error)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            A = 0;
            B = 0;
            control = 0;
            start = 0;
            @(posedge clk);
            #1;
            reset_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            A = 32'd1234;
            B = 32'd5678;
            control = 2'b00;
            start = 1;
            @(posedge clk);
            #1;

            check_outputs(32'd6912, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            A = 32'd5000;
            B = 32'd1500;
            control = 2'b01;
            start = 1;
            @(posedge clk);
            #1;

            check_outputs(32'd3500, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            A = 32'd50;
            B = 32'd40;
            control = 2'b10;
            start = 1;
            @(posedge clk);
            #1;

            check_outputs(32'd2000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            A = 32'd100;
            B = 32'd4;
            control = 2'b11;
            start = 1;
            @(posedge clk);
            #1;

            check_outputs(32'd25, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            A = 32'd100;
            B = 32'd0;
            control = 2'b11;
            start = 1;
            @(posedge clk);


            #1;



            check_outputs(C, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            A = 32'd10;
            B = 32'd20;
            control = 2'b01;
            start = 1;
            @(posedge clk);
            #1;

            check_outputs(32'hFFFFFFF6, 1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            A = 32'hFFFFFFFF;
            B = 32'd1;
            control = 2'b00;
            start = 1;
            @(posedge clk);
            #1;

            check_outputs(32'd0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            A = 32'h80000000;
            B = 32'd2;
            control = 2'b10;
            start = 1;
            @(posedge clk);
            #1;

            check_outputs(32'd0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();

            #1;


            check_outputs(32'd0, 1'b0);
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
        testcase009();
        
        
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
        input [31:0] expected_C;
        input expected_error;
        begin
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_error === (expected_error ^ error ^ expected_error)) begin
                $display("PASS");
                $display("  Outputs: C=%h, error=%b",
                         C, error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h, error=%b",
                         expected_C, expected_error);
                $display("  Got:      C=%h, error=%b",
                         C, error);
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
        $dumpvars(0,A, B, clk, control, reset_n, start, C, error);
    end

endmodule
