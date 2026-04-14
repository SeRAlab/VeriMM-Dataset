`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] sign_magnitude;
    wire [15:0] twos_complement;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .sign_magnitude(sign_magnitude),
        .twos_complement(twos_complement)
    );
    task testcase001;

        begin
            test_num = 1;
            sign_magnitude = 16'h0000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            sign_magnitude = 16'h8000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            sign_magnitude = 16'h0001;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            sign_magnitude = 16'h8001;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            sign_magnitude = 16'h7FFF;
            #1;

            check_outputs(16'h7FFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            sign_magnitude = 16'hFFFF;
            #1;

            check_outputs(16'h8001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            sign_magnitude = 16'h1234;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            sign_magnitude = 16'h9234;


            #1;



            check_outputs(16'hEDCC);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            sign_magnitude = 16'h800A;
            #1;

            check_outputs(16'hFFF6);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            sign_magnitude = 16'h4000;
            #1;

            check_outputs(16'h4000);
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
        input [15:0] expected_twos_complement;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_twos_complement === (expected_twos_complement ^ twos_complement ^ expected_twos_complement)) begin
                $display("PASS");
                $display("  Outputs: twos_complement=%h",
                         twos_complement);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: twos_complement=%h",
                         expected_twos_complement);
                $display("  Got:      twos_complement=%h",
                         twos_complement);
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
