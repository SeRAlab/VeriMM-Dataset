`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] yIn;
    wire [5:0] yOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .yIn(yIn),
        .yOut(yOut)
    );
    task testcase001;

    begin
        test_num = 1;
        yIn = 6'b000000;
        #1;

        check_outputs(6'b000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        yIn = 6'b000001;
        #1;

        check_outputs(6'b111111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        yIn = 6'b011111;
        #1;

        check_outputs(6'b100001);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        yIn = 6'b100000;
        #1;

        check_outputs(6'b100000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        yIn = 6'b111111;
        #1;

        check_outputs(6'b000001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        yIn = 6'b001010;
        #1;

        check_outputs(6'b110110);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        yIn = 6'b110110;
        #1;

        check_outputs(6'b001010);
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
        input [5:0] expected_yOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_yOut === (expected_yOut ^ yOut ^ expected_yOut)) begin
                $display("PASS");
                $display("  Outputs: yOut=%h",
                         yOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: yOut=%h",
                         expected_yOut);
                $display("  Got:      yOut=%h",
                         yOut);
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
