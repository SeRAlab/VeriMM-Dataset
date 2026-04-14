`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] compIn;
    wire [7:0] compOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .compIn(compIn),
        .compOut(compOut)
    );
    task testcase001;

        begin
            test_num = 1;
            compIn = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            compIn = 8'h01;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            compIn = 8'hFF;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            compIn = 8'h7F;
            #1;

            check_outputs(8'h81);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            compIn = 8'h80;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            compIn = 8'h81;
            #1;

            check_outputs(8'h7F);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            compIn = 8'h0A;
            #1;

            check_outputs(8'hF6);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            compIn = 8'hF6;
            #1;

            check_outputs(8'h0A);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            compIn = 8'h55;
            #1;

            check_outputs(8'hAB);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            compIn = 8'hAA;
            #1;

            check_outputs(8'h56);
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
        input [7:0] expected_compOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_compOut === (expected_compOut ^ compOut ^ expected_compOut)) begin
                $display("PASS");
                $display("  Outputs: compOut=%h",
                         compOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: compOut=%h",
                         expected_compOut);
                $display("  Got:      compOut=%h",
                         compOut);
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
