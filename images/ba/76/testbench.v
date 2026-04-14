`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A_DATA;
    reg MA;
    reg [31:0] PC_1;
    wire [31:0] Bus_A;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A_DATA(A_DATA),
        .MA(MA),
        .PC_1(PC_1),
        .Bus_A(Bus_A)
    );
    task testcase001;

        begin
            test_num = 1;
            MA = 1'b0;
            A_DATA = 32'hDEADBEEF;
            PC_1 = 32'hCAFEBABE;
            $display("Testcase %0d: MA=0, A_DATA=0xDEADBEEF, PC_1=0xCAFEBABE", test_num);
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            MA = 1'b1;
            A_DATA = 32'hDEADBEEF;
            PC_1 = 32'hCAFEBABE;
            $display("Testcase %0d: MA=1, A_DATA=0xDEADBEEF, PC_1=0xCAFEBABE", test_num);
            #1;

            check_outputs(32'hCAFEBABE);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            MA = 1'b0;
            A_DATA = 32'hFFFFFFFF;
            PC_1 = 32'h00000000;
            $display("Testcase %0d: MA=0, A_DATA=0xFFFFFFFF, PC_1=0x00000000", test_num);
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            MA = 1'b1;
            A_DATA = 32'hFFFFFFFF;
            PC_1 = 32'h00000000;
            $display("Testcase %0d: MA=1, A_DATA=0xFFFFFFFF, PC_1=0x00000000", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            MA = 1'b0;
            A_DATA = 32'hAAAAAAAA;
            PC_1 = 32'h55555555;
            $display("Testcase %0d: MA=0, A_DATA=0xAAAAAAAA, PC_1=0x55555555", test_num);
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            MA = 1'b1;
            A_DATA = 32'hAAAAAAAA;
            PC_1 = 32'h55555555;
            $display("Testcase %0d: MA=1, A_DATA=0xAAAAAAAA, PC_1=0x55555555", test_num);
            #1;

            check_outputs(32'h55555555);
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
        input [31:0] expected_Bus_A;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Bus_A === (expected_Bus_A ^ Bus_A ^ expected_Bus_A)) begin
                $display("PASS");
                $display("  Outputs: Bus_A=%h",
                         Bus_A);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Bus_A=%h",
                         expected_Bus_A);
                $display("  Got:      Bus_A=%h",
                         Bus_A);
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
