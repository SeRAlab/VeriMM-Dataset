`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [25:0] in;
    wire [27:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        in = 26'h0000000;
        #1;

        check_outputs(28'h0000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in = 26'h0000001;
        #1;

        check_outputs(28'h0000004);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in = 26'h3FFFFFF;
        #1;

        check_outputs(28'hFFFFFFFC);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in = 26'h2000000;
        #1;

        check_outputs(28'h8000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in = 26'h2AAAAAA;
        #1;

        check_outputs(28'hAAAAAA8);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in = 26'h1555555;
        #1;

        check_outputs(28'h5555554);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        in = 26'h0C0FFEE;
        #1;

        check_outputs(28'h303FFB8);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        in = 26'h35A5A5A;
        #1;

        check_outputs(28'hD696968);
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
        input [27:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
