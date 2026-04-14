`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] ABCD;
    reg clk;
    wire [1:0] XY;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ABCD(ABCD),
        .clk(clk),
        .XY(XY)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ABCD = 4'b0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            ABCD = 4'b0000;
            @(posedge clk);
            #1;
            $display("Test %0d: All inputs zero", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            ABCD = 4'b1000;
            @(posedge clk);
            #1;
            $display("Test %0d: Input A active (1000)", test_num);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            ABCD = 4'b0100;
            @(posedge clk);
            #1;
            $display("Test %0d: Input B active (0100)", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            ABCD = 4'b0010;
            @(posedge clk);
            #1;
            $display("Test %0d: Input C active (0010)", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            ABCD = 4'b0001;
            @(posedge clk);
            #1;
            $display("Test %0d: Input D active (0001)", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            ABCD = 4'b1100;
            @(posedge clk);
            #1;
            $display("Test %0d: Priority test A vs B (1100)", test_num);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            ABCD = 4'b0101;
            @(posedge clk);
            #1;
            $display("Test %0d: Priority test B vs D (0101)", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            ABCD = 4'b0011;
            @(posedge clk);
            #1;
            $display("Test %0d: Priority test C vs D (0011)", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            reset_dut();
            ABCD = 4'b1111;
            @(posedge clk);
            #1;
            $display("Test %0d: All inputs active (1111)", test_num);
            #1;

            check_outputs(2'b11);
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
        input [1:0] expected_XY;
        begin
            if (expected_XY === (expected_XY ^ XY ^ expected_XY)) begin
                $display("PASS");
                $display("  Outputs: XY=%h",
                         XY);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: XY=%h",
                         expected_XY);
                $display("  Got:      XY=%h",
                         XY);
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
        $dumpvars(0,ABCD, clk, XY);
    end

endmodule
