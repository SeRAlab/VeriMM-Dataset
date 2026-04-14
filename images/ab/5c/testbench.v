`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] INA;
    reg [31:0] INB;
    wire [31:0] OP;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .INA(INA),
        .INB(INB),
        .OP(OP)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            INA = 32'h00000000;
            INB = 32'h00000000;
            #10;
            $display("Test %0d: All Zeros", test_num);
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            INA = 32'hFFFFFFFF;
            INB = 32'hFFFFFFFF;
            #10;
            $display("Test %0d: All Ones", test_num);
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            INA = 32'h00000000;
            INB = 32'hFFFFFFFF;
            #10;
            $display("Test %0d: Complementary Inputs 1", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            INA = 32'hAAAAAAAA;
            INB = 32'hAAAAAAAA;
            #10;
            $display("Test %0d: Alternating Bits Equal", test_num);
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            INA = 32'hAAAAAAAA;
            INB = 32'h55555555;
            #10;
            $display("Test %0d: Alternating Bits Opposite", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            INA = 32'h12345678;
            INB = 32'h87654321;
            #10;









            $display("Test %0d: Mixed Hex Values", test_num);
            #1;

            check_outputs(32'h6AAE EAA6);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            INA = 32'hFFFFFFFF;
            INB = 32'hFFFFFFFE;
            #10;
            $display("Test %0d: Single Bit Difference", test_num);
            #1;

            check_outputs(32'hFFFFFFFE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            INA = 32'hF0F0F0F0;
            INB = 32'hFFFF0000;
            #10;



            $display("Test %0d: Nibble Patterns", test_num);
            #1;

            check_outputs(32'hF0F00F0F);
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
        input [31:0] expected_OP;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OP === (expected_OP ^ OP ^ expected_OP)) begin
                $display("PASS");
                $display("  Outputs: OP=%h",
                         OP);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OP=%h",
                         expected_OP);
                $display("  Got:      OP=%h",
                         OP);
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
