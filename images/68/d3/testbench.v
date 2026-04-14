`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] z;
    wire [8:0] Divide;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .z(z),
        .Divide(Divide)
    );
    task testcase001;

    begin
        test_num = 1;
        z = 8'h00;
        #1;

        check_outputs(9'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        z = 8'hFF;
        #1;

        check_outputs(9'h07F);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        z = 8'h01;
        #1;

        check_outputs(9'h000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        z = 8'h02;
        #1;

        check_outputs(9'h001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        z = 8'h80;
        #1;

        check_outputs(9'h040);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        z = 8'd100;
        #1;

        check_outputs(9'd50);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        z = 8'hAA;
        #1;

        check_outputs(9'h055);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        z = 8'h55;
        #1;

        check_outputs(9'h02A);
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
        input [8:0] expected_Divide;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Divide === (expected_Divide ^ Divide ^ expected_Divide)) begin
                $display("PASS");
                $display("  Outputs: Divide=%h",
                         Divide);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Divide=%h",
                         expected_Divide);
                $display("  Got:      Divide=%h",
                         Divide);
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
