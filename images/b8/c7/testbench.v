`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg S;
    reg [31:0] X;
    reg [31:0] Y;
    wire [31:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .S(S),
        .X(X),
        .Y(Y),
        .Z(Z)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select X (S=0)", test_num);
            X = 32'hAAAA_AAAA;
            Y = 32'h5555_5555;
            S = 1'b0;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select Y (S=1)", test_num);
            X = 32'hAAAA_AAAA;
            Y = 32'h5555_5555;
            S = 1'b1;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select X with all zeros", test_num);
            X = 32'h0000_0000;
            Y = 32'hFFFF_FFFF;
            S = 1'b0;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select Y with all ones", test_num);
            X = 32'h0000_0000;
            Y = 32'hFFFF_FFFF;
            S = 1'b1;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Select X with walking bits", test_num);
            X = 32'h1234_5678;
            Y = 32'h8765_4321;
            S = 1'b0;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Select Y with walking bits", test_num);
            X = 32'h1234_5678;
            Y = 32'h8765_4321;
            S = 1'b1;
            #1;

            check_outputs(32'h8765_4321);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Verify Y change doesn't affect Z when S=0", test_num);
            X = 32'hDEAD_BEEF;
            Y = 32'h0000_0000;
            S = 1'b0;
            #5;
            Y = 32'hFFFF_FFFF;
            #1;

            check_outputs(32'hDEAD_BEEF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Verify X change doesn't affect Z when S=1", test_num);
            X = 32'h0000_0000;
            Y = 32'hCAFE_BABE;
            S = 1'b1;
            #5;
            X = 32'hFFFF_FFFF;
            #1;

            check_outputs(32'hCAFE_BABE);
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
        input [31:0] expected_Z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%h",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%h",
                         expected_Z);
                $display("  Got:      Z=%h",
                         Z);
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
