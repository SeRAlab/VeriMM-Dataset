`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] InA;
    reg [2:0] InB;
    reg S;
    wire [2:0] Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .InA(InA),
        .InB(InB),
        .S(S),
        .Out(Out)
    );
    task testcase001;

        begin
            test_num = 1;
            InA = 3'b101;
            InB = 3'b010;
            S = 1'b0;
            $display("Testcase %03d: Select InA (S=0)", test_num);
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            InA = 3'b101;
            InB = 3'b010;
            S = 1'b1;
            $display("Testcase %03d: Select InB (S=1)", test_num);
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            InA = 3'b000;
            InB = 3'b111;
            S = 1'b0;
            $display("Testcase %03d: Select All-Zeros InA (S=0)", test_num);
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            InA = 3'b000;
            InB = 3'b111;
            S = 1'b1;
            $display("Testcase %03d: Select All-Ones InB (S=1)", test_num);
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            InA = 3'b110;
            InB = 3'b011;
            S = 1'b0;
            $display("Testcase %03d: Selective bit check InA (S=0)", test_num);
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            InA = 3'b110;
            InB = 3'b011;
            S = 1'b1;
            $display("Testcase %03d: Selective bit check InB (S=1)", test_num);
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            InA = 3'b111;
            InB = 3'b111;
            S = 1'b0;
            $display("Testcase %03d: Both inputs identical (S=0)", test_num);
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            InA = 3'b111;
            InB = 3'b111;
            S = 1'b1;
            $display("Testcase %03d: Both inputs identical (S=1)", test_num);
            #1;

            check_outputs(3'b111);
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
        input [2:0] expected_Out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Out === (expected_Out ^ Out ^ expected_Out)) begin
                $display("PASS");
                $display("  Outputs: Out=%h",
                         Out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out=%h",
                         expected_Out);
                $display("  Got:      Out=%h",
                         Out);
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
