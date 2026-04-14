`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] RegAddr;
    reg RegRA;
    wire [4:0] raRegAddr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RegAddr(RegAddr),
        .RegRA(RegRA),
        .raRegAddr(raRegAddr)
    );
    task testcase001;

        begin
            test_num = 1;
            RegRA = 1'b0;
            RegAddr = 5'b00000;
            $display("Test %0d: RegRA = 0, RegAddr = 5'b00000 (Pass through mode)", test_num);
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            RegRA = 1'b0;
            RegAddr = 5'b10101;
            $display("Test %0d: RegRA = 0, RegAddr = 5'b10101 (Pass through mode)", test_num);
            #1;

            check_outputs(5'b10101);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            RegRA = 1'b0;
            RegAddr = 5'b11111;
            $display("Test %0d: RegRA = 0, RegAddr = 5'b11111 (Pass through mode)", test_num);
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            RegRA = 1'b1;
            RegAddr = 5'b00000;
            $display("Test %0d: RegRA = 1, RegAddr = 5'b00000 (Force constant mode)", test_num);
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            RegRA = 1'b1;
            RegAddr = 5'b01100;
            $display("Test %0d: RegRA = 1, RegAddr = 5'b01100 (Force constant mode)", test_num);
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            RegRA = 1'b1;
            RegAddr = 5'b11111;
            $display("Test %0d: RegRA = 1, RegAddr = 5'b11111 (Force constant mode)", test_num);
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            RegRA = 1'b0;
            RegAddr = 5'b01111;
            $display("Test %0d: Return to RegRA = 0, RegAddr = 5'b01111", test_num);
            #1;

            check_outputs(5'b01111);
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
        input [4:0] expected_raRegAddr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_raRegAddr === (expected_raRegAddr ^ raRegAddr ^ expected_raRegAddr)) begin
                $display("PASS");
                $display("  Outputs: raRegAddr=%h",
                         raRegAddr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: raRegAddr=%h",
                         expected_raRegAddr);
                $display("  Got:      raRegAddr=%h",
                         raRegAddr);
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
