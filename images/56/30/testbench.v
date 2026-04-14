`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg MemRead;
    reg [4:0] rd;
    reg [4:0] rs1;
    reg [4:0] rs2;
    wire IF_IDwrite;
    wire PCwrite;
    wire control_sel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .MemRead(MemRead),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),
        .IF_IDwrite(IF_IDwrite),
        .PCwrite(PCwrite),
        .control_sel(control_sel)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Normal operation (MemRead=0, No Matches)", test_num);
        MemRead = 0;
        rd = 5'd10;
        rs1 = 5'd1;
        rs2 = 5'd2;

        #1;


        check_outputs(1, 1, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: No MemRead, Match present (Should not stall)", test_num);
        MemRead = 0;
        rd = 5'd5;
        rs1 = 5'd5;
        rs2 = 5'd2;

        #1;


        check_outputs(1, 1, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: MemRead=1, No Register Matches", test_num);
        MemRead = 1;
        rd = 5'd10;
        rs1 = 5'd1;
        rs2 = 5'd2;

        #1;


        check_outputs(1, 1, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Hazard Detection (MemRead=1, rd == rs1)", test_num);
        MemRead = 1;
        rd = 5'd15;
        rs1 = 5'd15;
        rs2 = 5'd2;

        #1;


        check_outputs(0, 0, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Hazard Detection (MemRead=1, rd == rs2)", test_num);
        MemRead = 1;
        rd = 5'd20;
        rs1 = 5'd1;
        rs2 = 5'd20;

        #1;


        check_outputs(0, 0, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Hazard Detection (MemRead=1, rd matches both rs1, rs2)", test_num);
        MemRead = 1;
        rd = 5'd7;
        rs1 = 5'd7;
        rs2 = 5'd7;

        #1;


        check_outputs(0, 0, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary check (Reg 0 match with MemRead)", test_num);
        MemRead = 1;
        rd = 5'd0;
        rs1 = 5'd0;
        rs2 = 5'd1;

        #1;


        check_outputs(0, 0, 1);
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
        input expected_IF_IDwrite;
        input expected_PCwrite;
        input expected_control_sel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_IF_IDwrite === (expected_IF_IDwrite ^ IF_IDwrite ^ expected_IF_IDwrite) &&
                expected_PCwrite === (expected_PCwrite ^ PCwrite ^ expected_PCwrite) &&
                expected_control_sel === (expected_control_sel ^ control_sel ^ expected_control_sel)) begin
                $display("PASS");
                $display("  Outputs: IF_IDwrite=%b, PCwrite=%b, control_sel=%b",
                         IF_IDwrite, PCwrite, control_sel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IF_IDwrite=%b, PCwrite=%b, control_sel=%b",
                         expected_IF_IDwrite, expected_PCwrite, expected_control_sel);
                $display("  Got:      IF_IDwrite=%b, PCwrite=%b, control_sel=%b",
                         IF_IDwrite, PCwrite, control_sel);
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
