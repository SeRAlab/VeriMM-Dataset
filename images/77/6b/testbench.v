`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    wire OVERFLOW;
    wire [7:0] PRODUCT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .OVERFLOW(OVERFLOW),
        .PRODUCT(PRODUCT)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 4'd0;
            B = 4'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            A = 4'sd3; B = 4'sd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'sd6);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            A = 4'sd4; B = -4'sd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, -8'sd8);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            A = 4'sd7; B = 4'sd7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'sd49);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            A = -4'sd8; B = -4'sd8;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'sd64);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            A = -4'sd8; B = 4'sd7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, -8'sd56);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            A = 4'sd0; B = -4'sd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'sd0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            A = -4'sd1; B = -4'sd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'sd1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            A = 4'sd4; B = 4'sd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'sd16);
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
        input expected_OVERFLOW;
        input [7:0] expected_PRODUCT;
        begin
            if (expected_OVERFLOW === (expected_OVERFLOW ^ OVERFLOW ^ expected_OVERFLOW) &&
                expected_PRODUCT === (expected_PRODUCT ^ PRODUCT ^ expected_PRODUCT)) begin
                $display("PASS");
                $display("  Outputs: OVERFLOW=%b, PRODUCT=%h",
                         OVERFLOW, PRODUCT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OVERFLOW=%b, PRODUCT=%h",
                         expected_OVERFLOW, expected_PRODUCT);
                $display("  Got:      OVERFLOW=%b, PRODUCT=%h",
                         OVERFLOW, PRODUCT);
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
        $dumpvars(0,A, B, clk, OVERFLOW, PRODUCT);
    end

endmodule
