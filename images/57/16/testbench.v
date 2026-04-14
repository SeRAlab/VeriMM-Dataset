`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data;
    wire [7:0] corrected_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .corrected_data(corrected_data)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros (8'h00)", test_num);
            data = 8'h00;
            #10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones (8'hFF)", test_num);
            data = 8'hFF;
            #10;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits (8'h55)", test_num);
            data = 8'h55;
            #10;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits (8'hAA)", test_num);
            data = 8'hAA;
            #10;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Walking One (8'h01)", test_num);
            data = 8'h01;
            #10;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Walking One (8'h80)", test_num);
            data = 8'h80;
            #10;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Data (8'h12)", test_num);
            data = 8'h12;
            #10;
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Data (8'hC3)", test_num);
            data = 8'hC3;
            #10;
            #1;

            check_outputs(8'hC3);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Prime Pattern (8'h1F)", test_num);
            data = 8'h1F;
            #10;
            #1;

            check_outputs(8'h1F);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Pattern (8'h7E)", test_num);
            data = 8'h7E;
            #10;
            #1;

            check_outputs(8'h7E);
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
        input [7:0] expected_corrected_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_corrected_data === (expected_corrected_data ^ corrected_data ^ expected_corrected_data)) begin
                $display("PASS");
                $display("  Outputs: corrected_data=%h",
                         corrected_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: corrected_data=%h",
                         expected_corrected_data);
                $display("  Got:      corrected_data=%h",
                         corrected_data);
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
