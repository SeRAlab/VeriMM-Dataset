`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire VNB;
    wire VPB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .VNB(VNB),
        .VPB(VPB)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin


            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 1);
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
        input expected_VNB;
        input expected_VPB;
        begin
            if (expected_VNB === (expected_VNB ^ VNB ^ expected_VNB) &&
                expected_VPB === (expected_VPB ^ VPB ^ expected_VPB)) begin
                $display("PASS");
                $display("  Outputs: VNB=%b, VPB=%b",
                         VNB, VPB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: VNB=%b, VPB=%b",
                         expected_VNB, expected_VPB);
                $display("  Got:      VNB=%b, VPB=%b",
                         VNB, VPB);
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
        $dumpvars(0,clk, VNB, VPB);
    end

endmodule
