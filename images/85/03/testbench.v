`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] inOne;
    reg [31:0] inTwo;
    reg select;
    wire [31:0] outSelect;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inOne(inOne),
        .inTwo(inTwo),
        .select(select),
        .outSelect(outSelect)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select inOne (select = 0)", test_num);
            inOne = 32'h12345678;
            inTwo = 32'h87654321;
            select = 1'b0;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select inTwo (select = 1)", test_num);
            inOne = 32'h12345678;
            inTwo = 32'h87654321;
            select = 1'b1;
            #1;

            check_outputs(32'h87654321);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select inOne (0x00000000 vs 0xFFFFFFFF)", test_num);
            inOne = 32'h00000000;
            inTwo = 32'hFFFFFFFF;
            select = 1'b0;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select inTwo (0x00000000 vs 0xFFFFFFFF)", test_num);
            inOne = 32'h00000000;
            inTwo = 32'hFFFFFFFF;
            select = 1'b1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select inOne (0x55555555 vs 0xAAAAAAAA)", test_num);
            inOne = 32'h55555555;
            inTwo = 32'hAAAAAAAA;
            select = 1'b0;
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select inTwo (0x55555555 vs 0xAAAAAAAA)", test_num);
            inOne = 32'h55555555;
            inTwo = 32'hAAAAAAAA;
            select = 1'b1;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select inOne with boundary values", test_num);
            inOne = 32'hFFFF_0000;
            inTwo = 32'h0000_FFFF;
            select = 1'b0;
            #1;

            check_outputs(32'hFFFF_0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select inTwo with boundary values", test_num);
            inOne = 32'hFFFF_0000;
            inTwo = 32'h0000_FFFF;
            select = 1'b1;
            #1;

            check_outputs(32'h0000_FFFF);
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
        input [31:0] expected_outSelect;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_outSelect === (expected_outSelect ^ outSelect ^ expected_outSelect)) begin
                $display("PASS");
                $display("  Outputs: outSelect=%h",
                         outSelect);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outSelect=%h",
                         expected_outSelect);
                $display("  Got:      outSelect=%h",
                         outSelect);
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
