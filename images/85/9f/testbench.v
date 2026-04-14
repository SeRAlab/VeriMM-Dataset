`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] inst;
    wire [31:0] imm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inst(inst),
        .imm(imm)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: I-type positive (imm=10)", test_num);
        inst = 32'h00A00093;
        #1;

        check_outputs(32'h0000000A);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: I-type negative (imm=-1)", test_num);
        inst = 32'hFFF00093;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: S-type positive (imm=10)", test_num);
        inst = 32'h00002523;
        #1;

        check_outputs(32'h0000000A);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: S-type negative (imm=-1)", test_num);
        inst = 32'hFE002F23;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: B-type positive (imm=4)", test_num);
        inst = 32'h00000263;
        #1;

        check_outputs(32'h00000004);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: B-type negative (imm=-2)", test_num);
        inst = 32'hFE000FA3;
        #1;

        check_outputs(32'hFFFFFFFE);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: U-type (imm=0x12345000)", test_num);
        inst = 32'h123450B7;
        #1;

        check_outputs(32'h12345000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: J-type positive (imm=4)", test_num);
        inst = 32'h004000EF;
        #1;

        check_outputs(32'h00000004);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: J-type negative (imm=-2)", test_num);
        inst = 32'hFFFFF0EF;
        #1;

        check_outputs(32'hFFFFFFFE);
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
        testcase009();
        
        
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
        input [31:0] expected_imm;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_imm === (expected_imm ^ imm ^ expected_imm)) begin
                $display("PASS");
                $display("  Outputs: imm=%h",
                         imm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: imm=%h",
                         expected_imm);
                $display("  Got:      imm=%h",
                         imm);
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
