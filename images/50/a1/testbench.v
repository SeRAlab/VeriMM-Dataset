`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] CBA;
    wire [7:0] F;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CBA(CBA),
        .F(F)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: CBA = 000", test_num);
            CBA = 3'b000;
            #1;

            check_outputs(8'b11111110);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: CBA = 001", test_num);
            CBA = 3'b001;
            #1;

            check_outputs(8'b11111101);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: CBA = 010", test_num);
            CBA = 3'b010;
            #1;

            check_outputs(8'b11111011);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: CBA = 011", test_num);
            CBA = 3'b011;
            #1;

            check_outputs(8'b11110111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: CBA = 100", test_num);
            CBA = 3'b100;
            #1;

            check_outputs(8'b11101111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: CBA = 101", test_num);
            CBA = 3'b101;
            #1;

            check_outputs(8'b11011111);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: CBA = 110", test_num);
            CBA = 3'b110;
            #1;

            check_outputs(8'b10111111);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: CBA = 111", test_num);
            CBA = 3'b111;
            #1;

            check_outputs(8'b01111111);
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
        input [7:0] expected_F;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_F === (expected_F ^ F ^ expected_F)) begin
                $display("PASS");
                $display("  Outputs: F=%h",
                         F);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: F=%h",
                         expected_F);
                $display("  Got:      F=%h",
                         F);
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
