`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A1;
    reg A2;
    reg A3;
    reg B1;
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .B1(B1),
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: (A1&A2) condition met, supply conditions met", test_num);
            A1 = 1; A2 = 1; A3 = 0; B1 = 0;
            VPWR = 1; VGND = 0;
            VPB = 1; VNB = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: (A3&B1) condition met, supply conditions met (alternate voltage set)", test_num);
            A1 = 0; A2 = 0; A3 = 1; B1 = 1;
            VPWR = 0; VGND = 1;
            VPB = 0; VNB = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input logic fails (A1&A2=0, A3&B1=0)", test_num);
            A1 = 1; A2 = 0; A3 = 1; B1 = 0;
            VPWR = 1; VGND = 0;
            VPB = 1; VNB = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Supply XOR condition fails (VPWR == VGND)", test_num);
            A1 = 1; A2 = 1; A3 = 1; B1 = 1;
            VPWR = 1; VGND = 1;
            VPB = 1; VNB = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Supply OR condition fails (VPB=0, VNB=0)", test_num);
            A1 = 1; A2 = 1; A3 = 1; B1 = 1;
            VPWR = 1; VGND = 0;
            VPB = 0; VNB = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both logic paths true, all supplies true", test_num);
            A1 = 1; A2 = 1; A3 = 1; B1 = 1;
            VPWR = 0; VGND = 1;
            VPB = 1; VNB = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Everything zero", test_num);
            A1 = 0; A2 = 0; A3 = 0; B1 = 0;
            VPWR = 0; VGND = 0;
            VPB = 0; VNB = 0;
            #1;

            check_outputs(1'b0);
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
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
