`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CTRL;
    reg [31:0] IN0;
    reg [31:0] IN1;
    wire [31:0] OUT1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CTRL(CTRL),
        .IN0(IN0),
        .IN1(IN1),
        .OUT1(OUT1)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select IN0 (CTRL=0)", test_num);
            CTRL = 1'b0;
            IN0 = 32'hDEADBEEF;
            IN1 = 32'hCAFEBABE;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select IN1 (CTRL=1)", test_num);
            CTRL = 1'b1;
            IN0 = 32'hDEADBEEF;
            IN1 = 32'hCAFEBABE;
            #1;

            check_outputs(32'hCAFEBABE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros, CTRL=0", test_num);
            CTRL = 1'b0;
            IN0 = 32'h00000000;
            IN1 = 32'hFFFFFFFF;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones, CTRL=1", test_num);
            CTRL = 1'b1;
            IN0 = 32'h00000000;
            IN1 = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits A, CTRL=0", test_num);
            CTRL = 1'b0;
            IN0 = 32'hAAAAAAAA;
            IN1 = 32'h55555555;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits 5, CTRL=1", test_num);
            CTRL = 1'b1;
            IN0 = 32'hAAAAAAAA;
            IN1 = 32'h55555555;
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Walk 1 on IN0, CTRL=0", test_num);
            CTRL = 1'b0;
            IN0 = 32'h80000000;
            IN1 = 32'h00000001;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Walk 1 on IN1, CTRL=1", test_num);
            CTRL = 1'b1;
            IN0 = 32'h80000000;
            IN1 = 32'h00000001;
            #1;

            check_outputs(32'h00000001);
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
        input [31:0] expected_OUT1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OUT1 === (expected_OUT1 ^ OUT1 ^ expected_OUT1)) begin
                $display("PASS");
                $display("  Outputs: OUT1=%h",
                         OUT1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT1=%h",
                         expected_OUT1);
                $display("  Got:      OUT1=%h",
                         OUT1);
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
