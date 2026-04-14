`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg extcon;
    reg [15:0] imm16;
    wire [31:0] extout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .extcon(extcon),
        .imm16(imm16),
        .extout(extout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Extension (extcon=0), imm16 MSB is 0", test_num);
            imm16 = 16'h1234;
            extcon = 1'b0;
            #1;

            check_outputs(32'h00001234);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Extension (extcon=0), imm16 MSB is 1", test_num);
            imm16 = 16'h8ABC;
            extcon = 1'b0;
            #1;

            check_outputs(32'h00008ABC);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sign Extension (extcon=1), imm16 MSB is 0", test_num);
            imm16 = 16'h7FFF;
            extcon = 1'b1;
            #1;

            check_outputs(32'h00007FFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sign Extension (extcon=1), imm16 MSB is 1", test_num);
            imm16 = 16'hFFFF;
            extcon = 1'b1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sign Extension (extcon=1), imm16 is negative value", test_num);
            imm16 = 16'hA5A5;
            extcon = 1'b1;
            #1;

            check_outputs(32'hFFFFA5A5);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Extension (extcon=0), imm16 is zero", test_num);
            imm16 = 16'h0000;
            extcon = 1'b0;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sign Extension (extcon=1), imm16 is zero", test_num);
            imm16 = 16'h0000;
            extcon = 1'b1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sign Extension (extcon=1), imm16 is minimum signed 16-bit", test_num);
            imm16 = 16'h8000;
            extcon = 1'b1;
            #1;

            check_outputs(32'hFFFF8000);
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
        input [31:0] expected_extout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_extout === (expected_extout ^ extout ^ expected_extout)) begin
                $display("PASS");
                $display("  Outputs: extout=%h",
                         extout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: extout=%h",
                         expected_extout);
                $display("  Got:      extout=%h",
                         extout);
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
