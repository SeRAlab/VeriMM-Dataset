`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] I;
    reg S;
    reg clk;
    wire [11:0] O0;
    wire [11:0] O1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I(I),
        .S(S),
        .clk(clk),
        .O0(O0),
        .O1(O1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting circuit...");
            I = 12'h000;
            S = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            I = 12'h000;
            S = 1'b0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(12'hFFF, 12'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            I = 12'hFFF;
            S = 1'b0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(12'h000, 12'h000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            I = 12'hA5A;
            S = 1'b0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(12'h5A5, 12'h000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            I = 12'h000;
            S = 1'b1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(12'hFFF, 12'hFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            I = 12'hFFF;
            S = 1'b1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(12'hFFF, 12'h000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            I = 12'hF0F;
            S = 1'b1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(12'hFFF, 12'h0F0);
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
        input [11:0] expected_O0;
        input [11:0] expected_O1;
        begin
            if (expected_O0 === (expected_O0 ^ O0 ^ expected_O0) &&
                expected_O1 === (expected_O1 ^ O1 ^ expected_O1)) begin
                $display("PASS");
                $display("  Outputs: O0=%h, O1=%h",
                         O0, O1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O0=%h, O1=%h",
                         expected_O0, expected_O1);
                $display("  Got:      O0=%h, O1=%h",
                         O0, O1);
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
        $dumpvars(0,I, S, clk, O0, O1);
    end

endmodule
