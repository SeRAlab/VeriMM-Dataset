`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [8:0] din_a;
    wire [7:0] dout_a;
    wire [7:0] dout_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din_a(din_a),
        .dout_a(dout_a),
        .dout_b(dout_b)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            din_a = 9'h000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input all zeros", test_num);
            reset_dut();
            din_a = 9'h000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input 0x0FF (lower byte all ones)", test_num);
            reset_dut();
            din_a = 9'h0FF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input 0x100 (Testing MSB truncation)", test_num);
            reset_dut();
            din_a = 9'h100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pattern 0x1AA", test_num);
            reset_dut();
            din_a = 9'h1AA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA, 8'hAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pattern 0x055", test_num);
            reset_dut();
            din_a = 9'h055;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55, 8'h55);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input 0x1FF", test_num);
            reset_dut();
            din_a = 9'h1FF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF, 8'hFF);
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
        input [7:0] expected_dout_a;
        input [7:0] expected_dout_b;
        begin
            if (expected_dout_a === (expected_dout_a ^ dout_a ^ expected_dout_a) &&
                expected_dout_b === (expected_dout_b ^ dout_b ^ expected_dout_b)) begin
                $display("PASS");
                $display("  Outputs: dout_a=%h, dout_b=%h",
                         dout_a, dout_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout_a=%h, dout_b=%h",
                         expected_dout_a, expected_dout_b);
                $display("  Got:      dout_a=%h, dout_b=%h",
                         dout_a, dout_b);
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
        $dumpvars(0,clk, din_a, dout_a, dout_b);
    end

endmodule
