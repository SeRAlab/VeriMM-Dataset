`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] EX2MEM_Rd;
    reg EX2MEM_RegWrite;
    reg [4:0] ID2EX_Rd;
    reg [4:0] ID2EX_Rs;
    reg [4:0] ID2EX_Rt;
    reg [4:0] IF2ID_Rs;
    reg [4:0] IF2ID_Rt;
    reg [4:0] MEM2WB_Rd;
    reg MEM2WB_RegWrite;
    wire [1:0] ForwardA;
    wire [1:0] ForwardB;
    wire ForwardC;
    wire ForwardD;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EX2MEM_Rd(EX2MEM_Rd),
        .EX2MEM_RegWrite(EX2MEM_RegWrite),
        .ID2EX_Rd(ID2EX_Rd),
        .ID2EX_Rs(ID2EX_Rs),
        .ID2EX_Rt(ID2EX_Rt),
        .IF2ID_Rs(IF2ID_Rs),
        .IF2ID_Rt(IF2ID_Rt),
        .MEM2WB_Rd(MEM2WB_Rd),
        .MEM2WB_RegWrite(MEM2WB_RegWrite),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB),
        .ForwardC(ForwardC),
        .ForwardD(ForwardD)
    );
    task initialize;

        begin
            EX2MEM_Rd = 0;
            EX2MEM_RegWrite = 0;
            ID2EX_Rd = 0;
            ID2EX_Rs = 0;
            ID2EX_Rt = 0;
            IF2ID_Rs = 0;
            IF2ID_Rt = 0;
            MEM2WB_Rd = 0;
            MEM2WB_RegWrite = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            initialize();
            EX2MEM_RegWrite = 1;
            MEM2WB_RegWrite = 1;
            EX2MEM_Rd = 5'd1;
            MEM2WB_Rd = 5'd2;
            ID2EX_Rs = 5'd3;
            ID2EX_Rt = 5'd4;
            IF2ID_Rs = 5'd5;
            IF2ID_Rt = 5'd6;
            #1;

            check_outputs(2'b00, 2'b00, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            initialize();
            EX2MEM_RegWrite = 1;
            EX2MEM_Rd = 5'd10;
            ID2EX_Rs = 5'd10;
            #1;

            check_outputs(2'b10, 2'b00, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            initialize();
            EX2MEM_RegWrite = 1;
            EX2MEM_Rd = 5'd15;
            ID2EX_Rt = 5'd15;
            #1;

            check_outputs(2'b00, 2'b10, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            initialize();
            MEM2WB_RegWrite = 1;
            MEM2WB_Rd = 5'd20;
            ID2EX_Rs = 5'd20;
            #1;

            check_outputs(2'b01, 2'b00, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            initialize();
            MEM2WB_RegWrite = 1;
            MEM2WB_Rd = 5'd25;
            ID2EX_Rt = 5'd25;
            #1;

            check_outputs(2'b00, 2'b01, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            initialize();
            EX2MEM_RegWrite = 1;
            MEM2WB_RegWrite = 1;
            EX2MEM_Rd = 5'd7;
            MEM2WB_Rd = 5'd7;
            ID2EX_Rs = 5'd7;
            #1;

            check_outputs(2'b10, 2'b00, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            initialize();
            EX2MEM_RegWrite = 1;
            EX2MEM_Rd = 5'd0;
            ID2EX_Rs = 5'd0;
            #1;

            check_outputs(2'b00, 2'b00, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            initialize();
            EX2MEM_RegWrite = 0;
            EX2MEM_Rd = 5'd12;
            ID2EX_Rs = 5'd12;
            #1;

            check_outputs(2'b00, 2'b00, 1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            initialize();
            EX2MEM_RegWrite = 1;
            EX2MEM_Rd = 5'd14;
            IF2ID_Rs = 5'd14;
            #1;

            check_outputs(2'b00, 2'b00, 1'b1, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            initialize();
            EX2MEM_RegWrite = 1;
            EX2MEM_Rd = 5'd16;
            IF2ID_Rt = 5'd16;
            #1;

            check_outputs(2'b00, 2'b00, 1'b0, 1'b1);
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
        input [1:0] expected_ForwardA;
        input [1:0] expected_ForwardB;
        input expected_ForwardC;
        input expected_ForwardD;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ForwardA === (expected_ForwardA ^ ForwardA ^ expected_ForwardA) &&
                expected_ForwardB === (expected_ForwardB ^ ForwardB ^ expected_ForwardB) &&
                expected_ForwardC === (expected_ForwardC ^ ForwardC ^ expected_ForwardC) &&
                expected_ForwardD === (expected_ForwardD ^ ForwardD ^ expected_ForwardD)) begin
                $display("PASS");
                $display("  Outputs: ForwardA=%h, ForwardB=%h, ForwardC=%b, ForwardD=%b",
                         ForwardA, ForwardB, ForwardC, ForwardD);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ForwardA=%h, ForwardB=%h, ForwardC=%b, ForwardD=%b",
                         expected_ForwardA, expected_ForwardB, expected_ForwardC, expected_ForwardD);
                $display("  Got:      ForwardA=%h, ForwardB=%h, ForwardC=%b, ForwardD=%b",
                         ForwardA, ForwardB, ForwardC, ForwardD);
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
