`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] PC4;
    reg [31:0] imm;
    wire [31:0] PC4_imm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PC4(PC4),
        .imm(imm),
        .PC4_imm(PC4_imm)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple positive offset", test_num);
            PC4 = 32'h00000004;
            imm = 32'h00000001;

            #1;


            check_outputs(32'h00000008);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero immediate", test_num);
            PC4 = 32'h00001000;
            imm = 32'h00000000;

            #1;


            check_outputs(32'h00001000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative offset (2's complement)", test_num);
            PC4 = 32'h00000100;
            imm = 32'hffffffff;

            #1;


            check_outputs(32'h000000fc);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Larger positive jump", test_num);
            PC4 = 32'h00000000;
            imm = 32'h00000100;

            #1;


            check_outputs(32'h00000400);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: PC wrap-around (overflow)", test_num);
            PC4 = 32'hfffffffc;
            imm = 32'h00000001;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large negative jump", test_num);
            PC4 = 32'h00000004;
            imm = 32'hfffffffe;

            #1;


            check_outputs(32'hfffffffc);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: High bits of imm shift", test_num);
            PC4 = 32'h12345678;
            imm = 32'h00000010;

            #1;


            check_outputs(32'h123456b8);
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
        input [31:0] expected_PC4_imm;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_PC4_imm === (expected_PC4_imm ^ PC4_imm ^ expected_PC4_imm)) begin
                $display("PASS");
                $display("  Outputs: PC4_imm=%h",
                         PC4_imm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PC4_imm=%h",
                         expected_PC4_imm);
                $display("  Got:      PC4_imm=%h",
                         PC4_imm);
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
