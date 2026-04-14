`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a0;
    reg [7:0] a1;
    reg [7:0] b0;
    reg [7:0] b1;
    reg clk;
    wire [15:0] z0;
    wire [15:0] z1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a0(a0),
        .a1(a1),
        .b0(b0),
        .b1(b1),
        .clk(clk),
        .z0(z0),
        .z1(z1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a0 = 0;
            b0 = 0;
            a1 = 0;
            b1 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %03d: Multiplications by Zero", test_num);
            a0 = 8'h00; b0 = 8'hFF;
            a1 = 8'hFF; b1 = 8'h00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %03d: Maximum Values (255 * 255)", test_num);
            a0 = 8'd255; b0 = 8'd255;
            a1 = 8'd255; b1 = 8'd255;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd65025, 16'd65025);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %03d: Identity Property", test_num);
            a0 = 8'd127; b0 = 8'd1;
            a1 = 8'd1;   b1 = 8'd200;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd127, 16'd200);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %03d: Powers of Two", test_num);
            a0 = 8'd16; b0 = 8'd16;
            a1 = 8'd64; b1 = 8'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd256, 16'd256);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %03d: Random Large Values", test_num);
            a0 = 8'd123; b0 = 8'd45;
            a1 = 8'd67;  b1 = 8'd89;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd5535, 16'd5963);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Testcase %03d: Alternating Patterns", test_num);
            a0 = 8'hAA; b0 = 8'h02;
            a1 = 8'h55; b1 = 8'h03;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd340, 16'd255);
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
        input [15:0] expected_z0;
        input [15:0] expected_z1;
        begin
            if (expected_z0 === (expected_z0 ^ z0 ^ expected_z0) &&
                expected_z1 === (expected_z1 ^ z1 ^ expected_z1)) begin
                $display("PASS");
                $display("  Outputs: z0=%h, z1=%h",
                         z0, z1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: z0=%h, z1=%h",
                         expected_z0, expected_z1);
                $display("  Got:      z0=%h, z1=%h",
                         z0, z1);
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
        $dumpvars(0,a0, a1, b0, b1, clk, z0, z1);
    end

endmodule
