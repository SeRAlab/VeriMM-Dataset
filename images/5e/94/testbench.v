`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] pcIn;
    wire [31:0] pcOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pcIn(pcIn),
        .pcOut(pcOut)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Initial PC value (0)", test_num);
            pcIn = 32'h00000000;
            #1;

            check_outputs(32'h00000004);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Sequential fetch from address 4", test_num);
            pcIn = 32'h00000004;
            #1;

            check_outputs(32'h00000008);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: PC in typical instruction memory range", test_num);
            pcIn = 32'h00001000;
            #1;

            check_outputs(32'h00001004);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Large PC value", test_num);
            pcIn = 32'hA5A5A5A5;
            #1;

            check_outputs(32'hA5A5A5A9);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: PC near boundary (0xFFFFFFF8)", test_num);
            pcIn = 32'hFFFFFFF8;
            #1;

            check_outputs(32'hFFFFFFFC);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: PC rollover case (0xFFFFFFFC + 4 = 0)", test_num);
            pcIn = 32'hFFFFFFFC;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: PC overflow with residual (0xFFFFFFFF + 4 = 3)", test_num);
            pcIn = 32'hFFFFFFFF;
            #1;

            check_outputs(32'h00000003);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Random pattern check", test_num);
            pcIn = 32'h12345678;
            #1;

            check_outputs(32'h1234567C);
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
        input [31:0] expected_pcOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pcOut === (expected_pcOut ^ pcOut ^ expected_pcOut)) begin
                $display("PASS");
                $display("  Outputs: pcOut=%h",
                         pcOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pcOut=%h",
                         expected_pcOut);
                $display("  Got:      pcOut=%h",
                         pcOut);
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
