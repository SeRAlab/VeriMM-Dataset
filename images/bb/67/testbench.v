`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    wire [31:0] ign;
    wire [3:0] ign2;
    wire [11:0] ign3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ign(ign),
        .ign2(ign2),
        .ign3(ign3)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase001: Initial state (amt=0)");


            #1;
            #1;

            check_outputs(32'h80000000, 4'h1, 12'h800);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase002: Shift by 1 (amt=1)");
            @(posedge clk);
            #2;



            #1;




            check_outputs(32'h40000000, 4'h2, 12'hC00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase003: Shift by 2 (amt=2)");
            @(posedge clk);
            #2;



            #1;




            check_outputs(32'h20000000, 4'h4, 12'hE00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase004: Shift by 3 (amt=3)");
            @(posedge clk);
            #2;



            #1;




            check_outputs(32'h10000000, 4'h8, 12'hF00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase005: Shift by 4 (amt=4)");
            @(posedge clk);
            #2;



            #1;




            check_outputs(32'h08000000, 4'h0, 12'hF80);
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
        input [31:0] expected_ign;
        input [3:0] expected_ign2;
        input [11:0] expected_ign3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ign === (expected_ign ^ ign ^ expected_ign) &&
                expected_ign2 === (expected_ign2 ^ ign2 ^ expected_ign2) &&
                expected_ign3 === (expected_ign3 ^ ign3 ^ expected_ign3)) begin
                $display("PASS");
                $display("  Outputs: ign=%h, ign2=%h, ign3=%h",
                         ign, ign2, ign3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ign=%h, ign2=%h, ign3=%h",
                         expected_ign, expected_ign2, expected_ign3);
                $display("  Got:      ign=%h, ign2=%h, ign3=%h",
                         ign, ign2, ign3);
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

endmodule
