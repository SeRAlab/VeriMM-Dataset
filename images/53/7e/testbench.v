`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] f;
    wire [11:0] g;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .f(f),
        .g(g)
    );
    task testcase001;

        begin
            test_num = 1;
            f = 12'd200;
            #1;

            check_outputs(12'd100);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            f = 12'd100;
            #1;

            check_outputs(12'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            f = 12'd4095;
            #1;

            check_outputs(12'd3995);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            f = 12'd0;

            #1;


            check_outputs(12'd3996);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            f = 12'd50;

            #1;


            check_outputs(12'd4046);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            f = 12'd101;
            #1;

            check_outputs(12'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            f = 12'hABC;

            #1;


            check_outputs(12'hA58);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            f = 12'd1000;
            #1;

            check_outputs(12'd900);
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
        input [11:0] expected_g;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_g === (expected_g ^ g ^ expected_g)) begin
                $display("PASS");
                $display("  Outputs: g=%h",
                         g);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: g=%h",
                         expected_g);
                $display("  Got:      g=%h",
                         g);
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
