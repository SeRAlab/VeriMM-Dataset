`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] IR;
    reg [15:0] Ra;
    reg [15:0] Rb;
    reg [1:0] aluControl;
    wire [15:0] aluOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IR(IR),
        .Ra(Ra),
        .Rb(Rb),
        .aluControl(aluControl),
        .aluOut(aluOut)
    );
    task testcase001;

        begin
            $display("\nTestcase 001: Pass Ra unchanged");
            test_num = 1;
            Ra = 16'h1234;
            Rb = 16'h5678;
            IR = 6'b000000;
            aluControl = 2'b00;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Add Ra and Rb (Register Mode)");
            test_num = 2;
            Ra = 16'h0010;
            Rb = 16'h0020;
            IR = 6'b000000;
            aluControl = 2'b01;
            #1;

            check_outputs(16'h0030);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Add Ra and Positive Immediate");
            test_num = 3;
            Ra = 16'h0100;
            Rb = 16'h0000;
            IR = 6'b100101;
            aluControl = 2'b01;
            #1;

            check_outputs(16'h0105);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Add Ra and Negative Immediate (Sign Extension)");
            test_num = 4;
            Ra = 16'h0010;
            Rb = 16'h0000;
            IR = 6'b111111;
            aluControl = 2'b01;
            #1;

            check_outputs(16'h000F);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Bitwise AND Ra and Rb");
            test_num = 5;
            Ra = 16'hF0F0;
            Rb = 16'hAAAA;
            IR = 6'b000000;
            aluControl = 2'b10;
            #1;

            check_outputs(16'hA0A0);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Bitwise AND Ra and Immediate");
            test_num = 6;
            Ra = 16'hFFFF;
            Rb = 16'h0000;
            IR = 6'b101010;
            aluControl = 2'b10;
            #1;

            check_outputs(16'h000A);
        end
        endtask

    task testcase007;

        begin
            $display("\nTestcase 007: Bitwise NOT Ra");
            test_num = 7;
            Ra = 16'h5555;
            Rb = 16'hFFFF;
            IR = 6'b000000;
            aluControl = 2'b11;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase008;

        begin
            $display("\nTestcase 008: Addition Overflow Wrap-around");
            test_num = 8;
            Ra = 16'hFFFF;
            Rb = 16'h0001;
            IR = 6'b000000;
            aluControl = 2'b01;
            #1;

            check_outputs(16'h0000);
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
        input [15:0] expected_aluOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_aluOut === (expected_aluOut ^ aluOut ^ expected_aluOut)) begin
                $display("PASS");
                $display("  Outputs: aluOut=%h",
                         aluOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aluOut=%h",
                         expected_aluOut);
                $display("  Got:      aluOut=%h",
                         aluOut);
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
