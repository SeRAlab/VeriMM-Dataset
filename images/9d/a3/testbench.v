`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] hiDiv;
    reg [31:0] hiMult;
    reg seletor;
    wire [31:0] HI;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .hiDiv(hiDiv),
        .hiMult(hiMult),
        .seletor(seletor),
        .HI(HI)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Select hiDiv (seletor=0) - Basic Pattern", test_num);
            hiDiv   = 32'hAAAA_AAAA;
            hiMult  = 32'h5555_5555;
            seletor = 1'b0;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Select hiMult (seletor=1) - Basic Pattern", test_num);
            hiDiv   = 32'hAAAA_AAAA;
            hiMult  = 32'h5555_5555;
            seletor = 1'b1;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Select hiDiv (seletor=0) - All Zeros vs All Ones", test_num);
            hiDiv   = 32'h0000_0000;
            hiMult  = 32'hFFFF_FFFF;
            seletor = 1'b0;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Select hiMult (seletor=1) - All Zeros vs All Ones", test_num);
            hiDiv   = 32'h0000_0000;
            hiMult  = 32'hFFFF_FFFF;
            seletor = 1'b1;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Select hiDiv (seletor=0) - Complex Hex Pattern", test_num);
            hiDiv   = 32'h1234_5678;
            hiMult  = 32'h8765_4321;
            seletor = 1'b0;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Select hiMult (seletor=1) - Complex Hex Pattern", test_num);
            hiDiv   = 32'h1234_5678;
            hiMult  = 32'h8765_4321;
            seletor = 1'b1;
            #1;

            check_outputs(32'h8765_4321);
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
        input [31:0] expected_HI;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_HI === (expected_HI ^ HI ^ expected_HI)) begin
                $display("PASS");
                $display("  Outputs: HI=%h",
                         HI);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: HI=%h",
                         expected_HI);
                $display("  Got:      HI=%h",
                         HI);
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
