`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg EXMEMRegWrite_i;
    reg [4:0] EXMEMforward_i;
    reg [4:0] IDEX1_i;
    reg [4:0] IDEX2_i;
    reg MEMWBRegWrite_i;
    reg [4:0] MEMforward_i;
    wire [1:0] MUXdown_o;
    wire [1:0] MUXup_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EXMEMRegWrite_i(EXMEMRegWrite_i),
        .EXMEMforward_i(EXMEMforward_i),
        .IDEX1_i(IDEX1_i),
        .IDEX2_i(IDEX2_i),
        .MEMWBRegWrite_i(MEMWBRegWrite_i),
        .MEMforward_i(MEMforward_i),
        .MUXdown_o(MUXdown_o),
        .MUXup_o(MUXup_o)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: No hazards, indices mismatch", test_num);
        EXMEMRegWrite_i = 0; EXMEMforward_i = 5'd0;
        MEMWBRegWrite_i = 0; MEMforward_i = 5'd0;
        IDEX1_i = 5'd1; IDEX2_i = 5'd2;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: EX Hazard on Register 1", test_num);
        EXMEMRegWrite_i = 1; EXMEMforward_i = 5'd10;
        MEMWBRegWrite_i = 0; MEMforward_i = 5'd0;
        IDEX1_i = 5'd10; IDEX2_i = 5'd2;
        #1;

        check_outputs(2'b00, 2'b10);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: EX Hazard on Register 2", test_num);
        EXMEMRegWrite_i = 1; EXMEMforward_i = 5'd15;
        MEMWBRegWrite_i = 0; MEMforward_i = 5'd0;
        IDEX1_i = 5'd1; IDEX2_i = 5'd15;
        #1;

        check_outputs(2'b10, 2'b00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: MEM Hazard on Register 1", test_num);
        EXMEMRegWrite_i = 0; EXMEMforward_i = 5'd0;
        MEMWBRegWrite_i = 1; MEMforward_i = 5'd20;
        IDEX1_i = 5'd20; IDEX2_i = 5'd2;
        #1;

        check_outputs(2'b00, 2'b01);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: MEM Hazard on Register 2", test_num);
        EXMEMRegWrite_i = 0; EXMEMforward_i = 5'd0;
        MEMWBRegWrite_i = 1; MEMforward_i = 5'd25;
        IDEX1_i = 5'd1; IDEX2_i = 5'd25;
        #1;

        check_outputs(2'b01, 2'b00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Priority Check (EX > MEM)", test_num);
        EXMEMRegWrite_i = 1; EXMEMforward_i = 5'd7;
        MEMWBRegWrite_i = 1; MEMforward_i = 5'd7;
        IDEX1_i = 5'd7; IDEX2_i = 5'd7;
        #1;

        check_outputs(2'b10, 2'b10);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Register 0 Hardwired Zero (No Forwarding)", test_num);
        EXMEMRegWrite_i = 1; EXMEMforward_i = 5'd0;
        MEMWBRegWrite_i = 1; MEMforward_i = 5'd0;
        IDEX1_i = 5'd0; IDEX2_i = 5'd0;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Match with RegWrite=0", test_num);
        EXMEMRegWrite_i = 0; EXMEMforward_i = 5'd5;
        MEMWBRegWrite_i = 0; MEMforward_i = 5'd5;
        IDEX1_i = 5'd5; IDEX2_i = 5'd5;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Mixed Hazards (IDEX1 from EX, IDEX2 from MEM)", test_num);
        EXMEMRegWrite_i = 1; EXMEMforward_i = 5'd11;
        MEMWBRegWrite_i = 1; MEMforward_i = 5'd22;
        IDEX1_i = 5'd11; IDEX2_i = 5'd22;
        #1;

        check_outputs(2'b01, 2'b10);
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
        input [1:0] expected_MUXdown_o;
        input [1:0] expected_MUXup_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_MUXdown_o === (expected_MUXdown_o ^ MUXdown_o ^ expected_MUXdown_o) &&
                expected_MUXup_o === (expected_MUXup_o ^ MUXup_o ^ expected_MUXup_o)) begin
                $display("PASS");
                $display("  Outputs: MUXdown_o=%h, MUXup_o=%h",
                         MUXdown_o, MUXup_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MUXdown_o=%h, MUXup_o=%h",
                         expected_MUXdown_o, expected_MUXup_o);
                $display("  Got:      MUXdown_o=%h, MUXup_o=%h",
                         MUXdown_o, MUXup_o);
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
