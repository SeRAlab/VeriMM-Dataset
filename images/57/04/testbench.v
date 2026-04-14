`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] q1;
    reg [31:0] q2;
    reg [31:0] q3;
    reg [31:0] q4;
    reg [1:0] reg_no;
    wire [31:0] regData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .q1(q1),
        .q2(q2),
        .q3(q3),
        .q4(q4),
        .reg_no(reg_no),
        .regData(regData)
    );
    task testcase001;

        begin
            test_num = 1;
            q1 = 32'hAAAAAAAA;
            q2 = 32'h00000000;
            q3 = 32'hFFFFFFFF;
            q4 = 32'h55555555;
            reg_no = 2'b00;
            $display("Testcase %0d: Selecting q1", test_num);
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            q1 = 32'hAAAAAAAA;
            q2 = 32'hBBBBBBBB;
            q3 = 32'hCCCCCCCC;
            q4 = 32'hDDDDDDDD;
            reg_no = 2'b01;
            $display("Testcase %0d: Selecting q2", test_num);
            #1;

            check_outputs(32'hBBBBBBBB);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            q1 = 32'h11111111;
            q2 = 222222222;
            q3 = 32'hDEADBEEF;
            q4 = 32'h0;
            reg_no = 2'b10;
            $display("Testcase %0d: Selecting q3", test_num);
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            q1 = 32'h0;
            q2 = 32'h1;
            q3 = 32'h2;
            q4 = 32'h33334444;
            reg_no = 2'b11;
            $display("Testcase %0d: Selecting q4", test_num);
            #1;

            check_outputs(32'h33334444);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            q1 = 32'hFFFFFFFF;
            q2 = 32'hEEEEEEEE;
            q3 = 32'hDDDDDDDD;
            q4 = 32'hCCCCCCCC;
            reg_no = 2'b00;
            $display("Testcase %0d: Selecting q1 (All Fs)", test_num);
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            q1 = 32'h12345678;
            q2 = 32'h87654321;
            q3 = 32'hABCDEF00;
            q4 = 32'h00FEDCBA;
            reg_no = 2'b10;
            $display("Testcase %0d: Switching to q3 in data stream", test_num);
            #1;

            check_outputs(32'hABCDEF00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            q1 = 32'h0; q2 = 32'h0; q3 = 32'h0; q4 = 32'h0;
            reg_no = 2'b11;
            $display("Testcase %0d: Selecting q4 with all zeros", test_num);
            #1;

            check_outputs(32'h00000000);
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
        input [31:0] expected_regData;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_regData === (expected_regData ^ regData ^ expected_regData)) begin
                $display("PASS");
                $display("  Outputs: regData=%h",
                         regData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: regData=%h",
                         expected_regData);
                $display("  Got:      regData=%h",
                         regData);
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
