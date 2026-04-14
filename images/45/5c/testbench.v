`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] seven_in;
    wire [6:0] seven_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .seven_in(seven_in),
        .seven_out(seven_out)
    );
    task testcase001;

    begin
        $display("Test 1: Input 0");
        seven_in = 5'd0;
        #1;

        check_outputs(7'h3f);
    end
        endtask

    task testcase002;

    begin
        $display("Test 2: Input 1");
        seven_in = 5'd1;
        #1;

        check_outputs(7'h06);
    end
        endtask

    task testcase003;

    begin
        $display("Test 3: Input 2");
        seven_in = 5'd2;
        #1;

        check_outputs(7'h5b);
    end
        endtask

    task testcase004;

    begin
        $display("Test 4: Input 3");
        seven_in = 5'd3;
        #1;

        check_outputs(7'h4f);
    end
        endtask

    task testcase005;

    begin
        $display("Test 5: Input 4");
        seven_in = 5'd4;
        #1;

        check_outputs(7'h66);
    end
        endtask

    task testcase006;

    begin
        $display("Test 6: Input 7");
        seven_in = 5'd7;
        #1;

        check_outputs(7'h07);
    end
        endtask

    task testcase007;

    begin
        $display("Test 7: Input 8");
        seven_in = 5'd8;
        #1;

        check_outputs(7'h7f);
    end
        endtask

    task testcase008;

    begin
        $display("Test 8: Input 10 (Letter A)");
        seven_in = 5'd10;
        #1;

        check_outputs(7'h77);
    end
        endtask

    task testcase009;

    begin
        $display("Test 9: Input 12 (Letter C)");
        seven_in = 5'd12;
        #1;

        check_outputs(7'h39);
    end
        endtask

    task testcase010;

    begin
        $display("Test 10: Input 15 (Letter F)");
        seven_in = 5'd15;
        #1;

        check_outputs(7'h71);
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
        input [6:0] expected_seven_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_seven_out === (expected_seven_out ^ seven_out ^ expected_seven_out)) begin
                $display("PASS");
                $display("  Outputs: seven_out=%h",
                         seven_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: seven_out=%h",
                         expected_seven_out);
                $display("  Got:      seven_out=%h",
                         seven_out);
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
