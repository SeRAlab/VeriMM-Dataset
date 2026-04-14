`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] EXtoMEM_RegRd;
    reg EXtoMEM_RegWrite;
    reg [4:0] IDtoEX_RegRs;
    reg [4:0] IDtoEX_RegRt;
    reg [4:0] MEMtoWB_RegRd;
    reg MEMtoWB_RegWrite;
    wire [1:0] ForwardA;
    wire [1:0] ForwardB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EXtoMEM_RegRd(EXtoMEM_RegRd),
        .EXtoMEM_RegWrite(EXtoMEM_RegWrite),
        .IDtoEX_RegRs(IDtoEX_RegRs),
        .IDtoEX_RegRt(IDtoEX_RegRt),
        .MEMtoWB_RegRd(MEMtoWB_RegRd),
        .MEMtoWB_RegWrite(MEMtoWB_RegWrite),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: No hazards (RegWrite disabled)", test_num);

        EXtoMEM_RegWrite = 0; MEMtoWB_RegWrite = 0;
        EXtoMEM_RegRd = 5'd10; MEMtoWB_RegRd = 5'd10;
        IDtoEX_RegRs = 5'd10;  IDtoEX_RegRt = 5'd10;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: EX Hazard on Rs (ForwardA = 2'b10)", test_num);
        EXtoMEM_RegWrite = 1; MEMtoWB_RegWrite = 0;
        EXtoMEM_RegRd = 5'd5; MEMtoWB_RegRd = 5'd0;
        IDtoEX_RegRs = 5'd5;  IDtoEX_RegRt = 5'd2;
        #1;

        check_outputs(2'b10, 2'b00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: EX Hazard on Rt (ForwardB = 2'b10)", test_num);
        EXtoMEM_RegWrite = 1; MEMtoWB_RegWrite = 0;
        EXtoMEM_RegRd = 5'd8; MEMtoWB_RegRd = 5'd0;
        IDtoEX_RegRs = 5'd1;  IDtoEX_RegRt = 5'd8;
        #1;

        check_outputs(2'b00, 2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: MEM Hazard on Rs (ForwardA = 2'b01)", test_num);
        EXtoMEM_RegWrite = 0; MEMtoWB_RegWrite = 1;
        EXtoMEM_RegRd = 5'd0; MEMtoWB_RegRd = 5'd12;
        IDtoEX_RegRs = 5'd12; IDtoEX_RegRt = 5'd3;
        #1;

        check_outputs(2'b01, 2'b00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: MEM Hazard on Rt (ForwardB = 2'b01)", test_num);
        EXtoMEM_RegWrite = 0; MEMtoWB_RegWrite = 1;
        EXtoMEM_RegRd = 5'd0; MEMtoWB_RegRd = 5'd15;
        IDtoEX_RegRs = 5'd4;  IDtoEX_RegRt = 5'd15;
        #1;

        check_outputs(2'b00, 2'b01);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Priority Hazard (EX stage priority over MEM stage)", test_num);

        EXtoMEM_RegWrite = 1; MEMtoWB_RegWrite = 1;
        EXtoMEM_RegRd = 5'd7; MEMtoWB_RegRd = 5'd7;
        IDtoEX_RegRs = 5'd7;  IDtoEX_RegRt = 5'd0;

        #1;


        check_outputs(2'b10, 2'b00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Register 0 Hazard (Should not forward for $zero)", test_num);
        EXtoMEM_RegWrite = 1; MEMtoWB_RegWrite = 1;
        EXtoMEM_RegRd = 5'd0; MEMtoWB_RegRd = 5'd0;
        IDtoEX_RegRs = 5'd0;  IDtoEX_RegRt = 5'd0;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Simultaneous different hazards", test_num);
        EXtoMEM_RegWrite = 1; MEMtoWB_RegWrite = 1;
        EXtoMEM_RegRd = 5'd1; MEMtoWB_RegRd = 5'd2;
        IDtoEX_RegRs = 5'd1;  IDtoEX_RegRt = 5'd2;

        #1;


        check_outputs(2'b10, 2'b01);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Register ID mismatch", test_num);
        EXtoMEM_RegWrite = 1; MEMtoWB_RegWrite = 1;
        EXtoMEM_RegRd = 5'd10; MEMtoWB_RegRd = 5'd20;
        IDtoEX_RegRs = 5'd5;   IDtoEX_RegRt = 5'd15;
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
        input [1:0] expected_ForwardA;
        input [1:0] expected_ForwardB;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ForwardA === (expected_ForwardA ^ ForwardA ^ expected_ForwardA) &&
                expected_ForwardB === (expected_ForwardB ^ ForwardB ^ expected_ForwardB)) begin
                $display("PASS");
                $display("  Outputs: ForwardA=%h, ForwardB=%h",
                         ForwardA, ForwardB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ForwardA=%h, ForwardB=%h",
                         expected_ForwardA, expected_ForwardB);
                $display("  Got:      ForwardA=%h, ForwardB=%h",
                         ForwardA, ForwardB);
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
