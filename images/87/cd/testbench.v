`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] IN1;
    reg [31:0] IN2;
    reg IR_CU;
    wire [31:0] OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IN1(IN1),
        .IN2(IN2),
        .IR_CU(IR_CU),
        .OUT(OUT)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Select IN1 (IR_CU = 0)", test_num);
        IN1 = 32'hAAAAAAAA;
        IN2 = 32'h55555555;
        IR_CU = 1'b0;
        #1;

        check_outputs(32'hAAAAAAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Select IN2 (IR_CU = 1)", test_num);
        IN1 = 32'hAAAAAAAA;
        IN2 = 32'h55555555;
        IR_CU = 1'b1;
        #1;

        check_outputs(32'h55555555);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Select IN1 (All 1s)", test_num);
        IN1 = 32'hFFFFFFFF;
        IN2 = 32'h00000000;
        IR_CU = 1'b0;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Select IN2 (All 0s)", test_num);
        IN1 = 32'hFFFFFFFF;
        IN2 = 32'h00000000;
        IR_CU = 1'b1;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Arbitrary Data Selection IN1", test_num);
        IN1 = 32'h12345678;
        IN2 = 32'h87654321;
        IR_CU = 1'b0;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Arbitrary Data Selection IN2", test_num);
        IN1 = 32'hDEADBEEF;
        IN2 = 32'hCAFEBABE;
        IR_CU = 1'b1;
        #1;

        check_outputs(32'hCAFEBABE);
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
        input [31:0] expected_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT)) begin
                $display("PASS");
                $display("  Outputs: OUT=%h",
                         OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%h",
                         expected_OUT);
                $display("  Got:      OUT=%h",
                         OUT);
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
