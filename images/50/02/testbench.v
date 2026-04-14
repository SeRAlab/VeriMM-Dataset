`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in0;
    reg [31:0] in1;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in0(in0),
        .in1(in1),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            in0 = 32'h00000000;
            in1 = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in0 = 32'hFFFFFFFF;
            in1 = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in0 = 32'hAAAAAAAA;
            in1 = 32'h55555555;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in0 = 32'hF0F0F0F0;
            in1 = 32'h0F0F0F0F;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in0 = 32'h12345678;
            in1 = 32'h87654321;
            #1;

            check_outputs(32'h97755779);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in0 = 32'hFFFF0000;
            in1 = 32'h0000FFFF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in0 = 32'hABCDE000;
            in1 = 32'h00001234;
            #1;

            check_outputs(32'hABCDE234);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in0 = 32'h0000CAFE;
            in1 = 32'h0000BABE;
            #1;

            check_outputs(32'h0000FAFE);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            in0 = 32'h1;
            in1 = 32'h2;
            #1;

            check_outputs(32'h3);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            in0 = 32'hDEADBEEF;
            in1 = 32'h00000000;
            #1;

            check_outputs(32'hDEADBEEF);
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
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
