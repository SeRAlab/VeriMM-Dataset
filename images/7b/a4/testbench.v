`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] PC_o;
    wire [31:0] PCadd4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PC_o(PC_o),
        .PCadd4(PCadd4)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: PC_o = 0", test_num);
            PC_o = 32'h00000000;
            #1;

            check_outputs(32'h00000004);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: PC_o = 0x00000004", test_num);
            PC_o = 32'h00000004;
            #1;

            check_outputs(32'h00000008);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: PC_o = 0x00000100", test_num);
            PC_o = 32'h00000100;
            #1;

            check_outputs(32'h00000104);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: PC_o = 0x12345678", test_num);
            PC_o = 32'h12345678;
            #1;

            check_outputs(32'h1234567C);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: PC_o = 0xFFFFFFFC (Overflow check)", test_num);
            PC_o = 32'hFFFFFFFC;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: PC_o = 0xFFFFFFF8", test_num);
            PC_o = 32'hFFFFFFF8;
            #1;

            check_outputs(32'hFFFFFFFC);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: PC_o = 0xAAAAAAA0", test_num);
            PC_o = 32'hAAAAAAA0;
            #1;

            check_outputs(32'hAAAAAAA4);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: PC_o = 0x55555554", test_num);
            PC_o = 32'h55555554;
            #1;

            check_outputs(32'h55555558);
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
        input [31:0] expected_PCadd4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_PCadd4 === (expected_PCadd4 ^ PCadd4 ^ expected_PCadd4)) begin
                $display("PASS");
                $display("  Outputs: PCadd4=%h",
                         PCadd4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PCadd4=%h",
                         expected_PCadd4);
                $display("  Got:      PCadd4=%h",
                         PCadd4);
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
