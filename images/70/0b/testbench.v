`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] R1;
    reg [7:0] R2;
    wire [15:0] outOr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .R1(R1),
        .R2(R2),
        .outOr(outOr)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        R1 = 8'h00;
        R2 = 8'h00;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        R1 = 8'hFF;
        R2 = 8'h00;
        #1;

        check_outputs(16'hFF00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        R1 = 8'h00;
        R2 = 8'hFF;
        #1;

        check_outputs(16'h00FF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        R1 = 8'hAA;
        R2 = 8'h55;
        #1;

        check_outputs(16'hAA55);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        R1 = 8'h12;
        R2 = 8'h34;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        R1 = 8'hFF;
        R2 = 8'hFF;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        R1 = 8'h80;
        R2 = 8'h01;
        #1;

        check_outputs(16'h8001);
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
        input [15:0] expected_outOr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_outOr === (expected_outOr ^ outOr ^ expected_outOr)) begin
                $display("PASS");
                $display("  Outputs: outOr=%h",
                         outOr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outOr=%h",
                         expected_outOr);
                $display("  Got:      outOr=%h",
                         outOr);
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
