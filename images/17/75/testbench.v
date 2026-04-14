`timescale 1ns/1ps

module DWT_Haar_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [7:0] x;
    wire [3:0] a;
    wire [3:0] d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DWT_Haar dut (
        .clk(clk),
        .rst(rst),
        .x(x),
        .a(a),
        .d(d)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            x = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Constant High Input (0xA0, 0xA0)", test_num);
            reset_dut();
            x = 8'hA0;
            @(posedge clk);
            x = 8'hA0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hA, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Zero Input (0x00, 0x00)", test_num);
            reset_dut();
            x = 8'h00;
            @(posedge clk);
            x = 8'h00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Step Down (0xC0, 0x40)", test_num);
            reset_dut();
            x = 8'hC0;
            @(posedge clk);
            x = 8'h40;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h8, 4'h4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Step Up (0x40, 0xC0)", test_num);
            reset_dut();
            x = 8'h40;
            @(posedge clk);
            x = 8'hC0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h8, 4'hC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Max Contrast (0xF0, 0x10)", test_num);
            reset_dut();
            x = 8'hF0;
            @(posedge clk);
            x = 8'h10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h8, 4'h7);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DWT_Haar Testbench");
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
        input [3:0] expected_a;
        input [3:0] expected_d;
        begin
            if (expected_a === (expected_a ^ a ^ expected_a) &&
                expected_d === (expected_d ^ d ^ expected_d)) begin
                $display("PASS");
                $display("  Outputs: a=%h, d=%h",
                         a, d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a=%h, d=%h",
                         expected_a, expected_d);
                $display("  Got:      a=%h, d=%h",
                         a, d);
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
        $dumpvars(0,clk, rst, x, a, d);
    end

endmodule
