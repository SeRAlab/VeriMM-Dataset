`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] extendedOffset;
    reg [31:0] nextPC;
    wire [31:0] branchPC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .extendedOffset(extendedOffset),
        .nextPC(nextPC),
        .branchPC(branchPC)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Zero inputs", test_num);
            nextPC = 32'h0000_0000;
            extendedOffset = 32'h0000_0000;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Small forward branch (Offset +1)", test_num);
            nextPC = 32'h0000_1000;
            extendedOffset = 32'h0000_0001;

            #1;


            check_outputs(32'h0000_1004);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Small backward branch (Offset -1)", test_num);
            nextPC = 32'h0000_1000;
            extendedOffset = 32'hFFFF_FFFF;

            #1;


            check_outputs(32'h0000_0FFC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Large forward branch", test_num);
            nextPC = 32'h1000_0000;
            extendedOffset = 32'h0000_1000;

            #1;


            check_outputs(32'h1000_4000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Large backward branch", test_num);
            nextPC = 32'h2000_0000;
            extendedOffset = 32'hFFFF_F000;

            #1;


            check_outputs(32'h1FFF_C000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: PC at upper memory boundary", test_num);
            nextPC = 32'hFFFF_FFF0;
            extendedOffset = 32'h0000_0001;

            #1;


            check_outputs(32'hFFFF_FFF4);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Maximum negative offset", test_num);
            nextPC = 32'h8000_0000;
            extendedOffset = 32'hE000_0000;


            #1;



            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Jump from zero with negative offset (Wrap around)", test_num);
            nextPC = 32'h0000_0000;
            extendedOffset = 32'hFFFF_FFFF;

            #1;


            check_outputs(32'hFFFF_FFFC);
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
        input [31:0] expected_branchPC;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_branchPC === (expected_branchPC ^ branchPC ^ expected_branchPC)) begin
                $display("PASS");
                $display("  Outputs: branchPC=%h",
                         branchPC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: branchPC=%h",
                         expected_branchPC);
                $display("  Got:      branchPC=%h",
                         branchPC);
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
