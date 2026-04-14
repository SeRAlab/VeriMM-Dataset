`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] float;
    wire [31:0] fixed_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .float(float),
        .fixed_out(fixed_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            float = 32'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            float = 32'h00000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            float = 32'h3F800000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            float = 32'h41700000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000000F);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            float = 32'hBF800000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            float = 32'hC1200000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFF6);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            float = 32'h3F000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            float = 32'h4F800000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h7FFFFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            float = 32'hCF800000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            float = 32'h80000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            float = 32'h4E800000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h40000000);
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
        testcase010();
        
        
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
        input [31:0] expected_fixed_out;
        begin
            if (expected_fixed_out === (expected_fixed_out ^ fixed_out ^ expected_fixed_out)) begin
                $display("PASS");
                $display("  Outputs: fixed_out=%h",
                         fixed_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fixed_out=%h",
                         expected_fixed_out);
                $display("  Got:      fixed_out=%h",
                         fixed_out);
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
        $dumpvars(0,clk, float, fixed_out);
    end

endmodule
