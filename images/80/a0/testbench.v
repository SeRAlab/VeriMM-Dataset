`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg RegWrite_EX;
    reg RegWrite_MEM;
    reg [4:0] rd_EX;
    reg [4:0] rd_MEM;
    reg [4:0] rs;
    reg [4:0] rt;
    wire [1:0] ALUScrA;
    wire [1:0] ALUScrB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RegWrite_EX(RegWrite_EX),
        .RegWrite_MEM(RegWrite_MEM),
        .rd_EX(rd_EX),
        .rd_MEM(rd_MEM),
        .rs(rs),
        .rt(rt),
        .ALUScrA(ALUScrA),
        .ALUScrB(ALUScrB)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: No Hazards", test_num);
        rs = 5'd1;
        rt = 5'd2;
        rd_EX = 5'd3;
        rd_MEM = 5'd4;
        RegWrite_EX = 1'b1;
        RegWrite_MEM = 1'b1;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: EX Hazard on rs", test_num);
        rs = 5'd10;
        rt = 5'd11;
        rd_EX = 5'd10;
        rd_MEM = 5'd12;
        RegWrite_EX = 1'b1;
        RegWrite_MEM = 1'b1;
        #1;

        check_outputs(2'b10, 2'b00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: EX Hazard on rt", test_num);
        rs = 5'd1;
        rt = 5'd2;
        rd_EX = 5'd2;
        rd_MEM = 5'd3;
        RegWrite_EX = 1'b1;
        RegWrite_MEM = 1'b1;
        #1;

        check_outputs(2'b00, 2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: MEM Hazard on rs", test_num);
        rs = 5'd15;
        rt = 5'd16;
        rd_EX = 5'd17;
        rd_MEM = 5'd15;
        RegWrite_EX = 1'b1;
        RegWrite_MEM = 1'b1;
        #1;

        check_outputs(2'b01, 2'b00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: MEM Hazard on rt", test_num);
        rs = 5'd20;
        rt = 5'd21;
        rd_EX = 5'd22;
        rd_MEM = 5'd21;
        RegWrite_EX = 1'b1;
        RegWrite_MEM = 1'b1;
        #1;

        check_outputs(2'b00, 2'b01);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: EX Hazard Priority on rs", test_num);
        rs = 5'd5;
        rt = 5'd6;
        rd_EX = 5'd5;
        rd_MEM = 5'd5;
        RegWrite_EX = 1'b1;
        RegWrite_MEM = 1'b1;
        #1;

        check_outputs(2'b10, 2'b00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: EX Hazard Priority on rt", test_num);
        rs = 5'd8;
        rt = 5'd9;
        rd_EX = 5'd9;
        rd_MEM = 5'd9;
        RegWrite_EX = 1'b1;
        RegWrite_MEM = 1'b1;
        #1;

        check_outputs(2'b00, 2'b10);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Register $0 No Forwarding", test_num);
        rs = 5'd0;
        rt = 5'd0;
        rd_EX = 5'd0;
        rd_MEM = 5'd0;
        RegWrite_EX = 1'b1;
        RegWrite_MEM = 1'b1;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: RegWrite Disabled Check", test_num);
        rs = 5'd10;
        rt = 5'd11;
        rd_EX = 5'd10;
        rd_MEM = 5'd11;
        RegWrite_EX = 1'b0;
        RegWrite_MEM = 1'b0;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Mixed rs(EX) and rt(MEM) Hazards", test_num);
        rs = 5'd4;
        rt = 5'd7;
        rd_EX = 5'd4;
        rd_MEM = 5'd7;
        RegWrite_EX = 1'b1;
        RegWrite_MEM = 1'b1;
        #1;

        check_outputs(2'b10, 2'b01);
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
        input [1:0] expected_ALUScrA;
        input [1:0] expected_ALUScrB;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALUScrA === (expected_ALUScrA ^ ALUScrA ^ expected_ALUScrA) &&
                expected_ALUScrB === (expected_ALUScrB ^ ALUScrB ^ expected_ALUScrB)) begin
                $display("PASS");
                $display("  Outputs: ALUScrA=%h, ALUScrB=%h",
                         ALUScrA, ALUScrB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALUScrA=%h, ALUScrB=%h",
                         expected_ALUScrA, expected_ALUScrB);
                $display("  Got:      ALUScrA=%h, ALUScrB=%h",
                         ALUScrA, ALUScrB);
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
