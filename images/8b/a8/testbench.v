`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] InY;
    wire Reduced_NAND;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .InY(InY),
        .Reduced_NAND(Reduced_NAND)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All zeros input (expecting 1)", test_num);
        InY = 8'b00000000;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All ones input (expecting 0)", test_num);
        InY = 8'b11111111;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single zero at LSB (expecting 1)", test_num);
        InY = 8'b11111110;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single zero at MSB (expecting 1)", test_num);
        InY = 8'b01111111;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating bits 10101010 (expecting 1)", test_num);
        InY = 8'b10101010;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating bits 01010101 (expecting 1)", test_num);
        InY = 8'b01010101;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mid-range value (expecting 1)", test_num);
        InY = 8'hF0;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single one at bit 4 (expecting 1)", test_num);
        InY = 8'b00010000;
        #10;
        #1;

        check_outputs(1'b1);
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
        input expected_Reduced_NAND;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Reduced_NAND === (expected_Reduced_NAND ^ Reduced_NAND ^ expected_Reduced_NAND)) begin
                $display("PASS");
                $display("  Outputs: Reduced_NAND=%b",
                         Reduced_NAND);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Reduced_NAND=%b",
                         expected_Reduced_NAND);
                $display("  Got:      Reduced_NAND=%b",
                         Reduced_NAND);
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
