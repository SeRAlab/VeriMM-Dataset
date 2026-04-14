`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] binary;
    wire [7:0] excess_3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary(binary),
        .excess_3(excess_3)
    );
    task testcase001;

    begin
        test_num = 1;
        binary = 4'd0;
        #1;

        check_outputs(8'h33);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        binary = 4'd1;
        #1;

        check_outputs(8'h34);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        binary = 4'd5;
        #1;

        check_outputs(8'h38);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        binary = 4'd9;
        #1;

        check_outputs(8'h3C);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        binary = 4'd10;
        #1;

        check_outputs(8'h43);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        binary = 4'd12;
        #1;

        check_outputs(8'h45);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        binary = 4'd15;
        #1;

        check_outputs(8'h48);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        binary = 4'd7;
        #1;

        check_outputs(8'h3A);
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
        input [7:0] expected_excess_3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_excess_3 === (expected_excess_3 ^ excess_3 ^ expected_excess_3)) begin
                $display("PASS");
                $display("  Outputs: excess_3=%h",
                         excess_3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: excess_3=%h",
                         expected_excess_3);
                $display("  Got:      excess_3=%h",
                         excess_3);
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
