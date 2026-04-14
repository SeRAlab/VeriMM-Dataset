`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] R1;
    reg WRITEPORTSELECT;
    wire [4:0] WritePort;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .R1(R1),
        .WRITEPORTSELECT(WRITEPORTSELECT),
        .WritePort(WritePort)
    );
    task testcase001;

    begin
        test_num = 1;
        R1 = 5'b00000;
        WRITEPORTSELECT = 1'b0;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        R1 = 5'b11111;
        WRITEPORTSELECT = 1'b0;
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        R1 = 5'b10101;
        WRITEPORTSELECT = 1'b0;
        #1;

        check_outputs(5'b10101);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        R1 = 5'b00000;
        WRITEPORTSELECT = 1'b1;
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        R1 = 5'b10101;
        WRITEPORTSELECT = 1'b1;
        #1;

        check_outputs(5'b11111);
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
        input [4:0] expected_WritePort;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_WritePort === (expected_WritePort ^ WritePort ^ expected_WritePort)) begin
                $display("PASS");
                $display("  Outputs: WritePort=%h",
                         WritePort);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: WritePort=%h",
                         expected_WritePort);
                $display("  Got:      WritePort=%h",
                         WritePort);
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
