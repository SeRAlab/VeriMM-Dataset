`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg EXMEMregWrite;
    reg [4:0] EXMEMregisterRd;
    reg MEMWBregWrite;
    reg [4:0] MEMWBregisterRd;
    reg [4:0] rd;
    reg [4:0] rs;
    reg rst;
    reg [4:0] rt;
    wire [1:0] forwardA;
    wire [1:0] forwardB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EXMEMregWrite(EXMEMregWrite),
        .EXMEMregisterRd(EXMEMregisterRd),
        .MEMWBregWrite(MEMWBregWrite),
        .MEMWBregisterRd(MEMWBregisterRd),
        .rd(rd),
        .rs(rs),
        .rst(rst),
        .rt(rt),
        .forwardA(forwardA),
        .forwardB(forwardB)
    );
    task reset_system;

        begin
            rst = 1;
            EXMEMregWrite = 0;
            EXMEMregisterRd = 0;
            MEMWBregWrite = 0;
            MEMWBregisterRd = 0;
            rd = 0;
            rs = 0;
            rt = 0;
            #10;
            rst = 0;
            #10;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Behavior", test_num);
            reset_system;

            rst = 1;
            rs = 5'd10;
            EXMEMregWrite = 1;
            EXMEMregisterRd = 5'd10;
            #5;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: No Hazard (Normal operation)", test_num);
            reset_system;
            rs = 5'd1;
            rt = 5'd2;
            EXMEMregWrite = 0;
            MEMWBregWrite = 0;
            EXMEMregisterRd = 5'd3;
            MEMWBregisterRd = 5'd4;
            #5;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: EX Hazard on rs", test_num);
            reset_system;
            rs = 5'd15;
            rt = 5'd2;
            EXMEMregWrite = 1;
            EXMEMregisterRd = 5'd15;
            #5;
            #1;

            check_outputs(2'b10, 2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: EX Hazard on rt", test_num);
            reset_system;
            rs = 5'd1;
            rt = 5'd20;
            EXMEMregWrite = 1;
            EXMEMregisterRd = 5'd20;
            #5;
            #1;

            check_outputs(2'b00, 2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: MEM Hazard on rs", test_num);
            reset_system;
            rs = 5'd8;
            rt = 5'd2;
            MEMWBregWrite = 1;
            MEMWBregisterRd = 5'd8;
            EXMEMregWrite = 0;
            #5;
            #1;

            check_outputs(2'b01, 2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: MEM Hazard on rt", test_num);
            reset_system;
            rs = 5'd1;
            rt = 5'd25;
            MEMWBregWrite = 1;
            MEMWBregisterRd = 5'd25;
            EXMEMregWrite = 0;
            #5;
            #1;

            check_outputs(2'b00, 2'b01);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Priority - EX over MEM Hazard for rs", test_num);
            reset_system;
            rs = 5'd12;
            EXMEMregWrite = 1;
            EXMEMregisterRd = 5'd12;
            MEMWBregWrite = 1;
            MEMWBregisterRd = 5'd12;
            #5;

            #1;


            check_outputs(2'b10, 2'b00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Register $zero Check (No forwarding)", test_num);
            reset_system;
            rs = 5'd0;
            rt = 5'd0;
            EXMEMregWrite = 1;
            EXMEMregisterRd = 5'd0;
            MEMWBregWrite = 1;
            MEMWBregisterRd = 5'd0;
            #5;

            #1;


            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Mixed Hazards (rs from EX, rt from MEM)", test_num);
            reset_system;
            rs = 5'd4;
            rt = 5'd5;
            EXMEMregWrite = 1;
            EXMEMregisterRd = 5'd4;
            MEMWBregWrite = 1;
            MEMWBregisterRd = 5'd5;
            #5;
            #1;

            check_outputs(2'b10, 2'b01);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: RegWrite Signal Check", test_num);
            reset_system;
            rs = 5'd10;
            EXMEMregisterRd = 5'd10;
            EXMEMregWrite = 0;
            #5;
            #1;

            check_outputs(2'b00, 2'b00);
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
        testcase010();
        
        
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
        input [1:0] expected_forwardA;
        input [1:0] expected_forwardB;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_forwardA === (expected_forwardA ^ forwardA ^ expected_forwardA) &&
                expected_forwardB === (expected_forwardB ^ forwardB ^ expected_forwardB)) begin
                $display("PASS");
                $display("  Outputs: forwardA=%h, forwardB=%h",
                         forwardA, forwardB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: forwardA=%h, forwardB=%h",
                         expected_forwardA, expected_forwardB);
                $display("  Got:      forwardA=%h, forwardB=%h",
                         forwardA, forwardB);
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
