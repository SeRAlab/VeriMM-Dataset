`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] NPC;
    reg [15:0] data;
    wire [7:0] PC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .NPC(NPC),
        .data(data),
        .PC(PC)
    );
    task testcase001;

        begin
            test_num = 1;
            NPC = 8'h01;

            data = 16'h055A;
            #10;
            $display("Test %0d: BEQ Taken (5==5)", test_num);
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            NPC = 8'h02;

            data = 16'h056A;
            #10;
            $display("Test %0d: BEQ Not Taken (5!=6)", test_num);
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            NPC = 8'h03;

            data = 16'h1AB2;
            #10;
            $display("Test %0d: BNE Taken (A!=B)", test_num);
            #1;

            check_outputs(8'hB2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            NPC = 8'h04;

            data = 16'h1AA2;
            #10;
            $display("Test %0d: BNE Not Taken (A==A)", test_num);
            #1;

            check_outputs(8'h04);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            NPC = 8'h05;

            data = 16'h20FF;
            #10;
            $display("Test %0d: Unconditional Jump", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            NPC = 8'h22;

            data = 16'h3000;
            #10;
            $display("Test %0d: Default (No Branch)", test_num);
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            NPC = 8'hE0;

            data = 16'h2000;
            #10;
            $display("Test %0d: Jump to Address 0x00", test_num);
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_PC;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_PC === (expected_PC ^ PC ^ expected_PC)) begin
                $display("PASS");
                $display("  Outputs: PC=%h",
                         PC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PC=%h",
                         expected_PC);
                $display("  Got:      PC=%h",
                         PC);
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
