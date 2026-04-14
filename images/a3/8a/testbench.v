`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [13:0] oh1;
    wire [25:0] control;
    wire [15:0] literal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .oh1(oh1),
        .control(control),
        .literal(literal)
    );
    task testcase001;

    begin
        $display("Running Testcase 001: oh1[13:9] = 5'b00001");
        oh1 = 14'h0000;
        #5;
        oh1 = 14'b00001_101010101;



        #1;




        check_outputs(26'h0000001, 16'h0155);
    end
        endtask

    task testcase002;

    begin
        $display("Running Testcase 002: oh1[13:9] = 5'b00010");
        oh1 = 14'h0000;
        #5;
        oh1 = 14'b00010_011110000;

        #1;


        check_outputs(26'h0000002, 16'h0F00);
    end
        endtask

    task testcase003;

    begin
        $display("Running Testcase 003: oh1[13:9] = 5'b01000");
        oh1 = 14'h0000;
        #5;
        oh1 = 14'b01000_111111111;

        #1;


        check_outputs(26'h0000008, 16'hFFFF);
    end
        endtask

    task testcase004;

    begin
        $display("Running Testcase 004: oh1[13:9] = 5'b10000");
        oh1 = 14'h0000;
        #5;
        oh1 = 14'b10000_000000001;

        #1;


        check_outputs(26'h0000010, 16'h8001);
    end
        endtask

    task testcase005;

    begin
        $display("Running Testcase 005: Undefined input range (Default)");
        oh1 = 14'h0000;
        #5;
        oh1 = 14'b11111_000000000;

        #1;


        check_outputs(26'h0, 16'h0);
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
        input [25:0] expected_control;
        input [15:0] expected_literal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_control === (expected_control ^ control ^ expected_control) &&
                expected_literal === (expected_literal ^ literal ^ expected_literal)) begin
                $display("PASS");
                $display("  Outputs: control=%h, literal=%h",
                         control, literal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control=%h, literal=%h",
                         expected_control, expected_literal);
                $display("  Got:      control=%h, literal=%h",
                         control, literal);
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
