`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg B_sel;
    reg [4:0] EX_MEM_rd;
    reg [4:0] MEM_WB_rd;
    reg RegW_in1;
    reg RegW_in2;
    reg [4:0] rs1;
    reg [4:0] rs2;
    wire [1:0] fa;
    wire [1:0] fb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .B_sel(B_sel),
        .EX_MEM_rd(EX_MEM_rd),
        .MEM_WB_rd(MEM_WB_rd),
        .RegW_in1(RegW_in1),
        .RegW_in2(RegW_in2),
        .rs1(rs1),
        .rs2(rs2),
        .fa(fa),
        .fb(fb)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: No hazards", test_num);
        rs1 = 5'd1; rs2 = 5'd2;
        EX_MEM_rd = 5'd3; MEM_WB_rd = 5'd4;
        RegW_in1 = 1'b1; RegW_in2 = 1'b1;
        B_sel = 1'b0;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: EX Hazard on rs1", test_num);
        rs1 = 5'd5; rs2 = 5'd2;
        EX_MEM_rd = 5'd5; MEM_WB_rd = 5'd4;
        RegW_in1 = 1'b1; RegW_in2 = 1'b1;
        B_sel = 1'b0;
        #1;

        check_outputs(2'b10, 2'b00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: EX Hazard on rs2", test_num);
        rs1 = 5'd1; rs2 = 5'd6;
        EX_MEM_rd = 5'd6; MEM_WB_rd = 5'd4;
        RegW_in1 = 1'b1; RegW_in2 = 1'b1;
        B_sel = 1'b0;
        #1;

        check_outputs(2'b00, 2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: MEM Hazard on rs1", test_num);
        rs1 = 5'd7; rs2 = 5'd2;
        EX_MEM_rd = 5'd3; MEM_WB_rd = 5'd7;
        RegW_in1 = 1'b1; RegW_in2 = 1'b1;
        B_sel = 1'b0;
        #1;

        check_outputs(2'b01, 2'b00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: MEM Hazard on rs2", test_num);
        rs1 = 5'd1; rs2 = 5'd8;
        EX_MEM_rd = 5'd3; MEM_WB_rd = 5'd8;
        RegW_in1 = 1'b1; RegW_in2 = 1'b1;
        B_sel = 1'b0;
        #1;

        check_outputs(2'b00, 2'b01);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Priority Test (EX vs MEM hazard)", test_num);
        rs1 = 5'd10; rs2 = 5'd10;
        EX_MEM_rd = 5'd10; MEM_WB_rd = 5'd10;
        RegW_in1 = 1'b1; RegW_in2 = 1'b1;
        B_sel = 1'b0;
        #1;

        check_outputs(2'b10, 2'b10);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: x0 No-Forwarding Check", test_num);
        rs1 = 5'd0; rs2 = 5'd0;
        EX_MEM_rd = 5'd0; MEM_WB_rd = 5'd0;
        RegW_in1 = 1'b1; RegW_in2 = 1'b1;
        B_sel = 1'b0;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: RegWrite Disabled Check", test_num);
        rs1 = 5'd12; rs2 = 5'd12;
        EX_MEM_rd = 5'd12; MEM_WB_rd = 5'd12;
        RegW_in1 = 1'b0; RegW_in2 = 1'b0;
        B_sel = 1'b0;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: B_sel Special Case", test_num);
        rs1 = 5'd1; rs2 = 5'd2;
        EX_MEM_rd = 5'd3; MEM_WB_rd = 5'd4;
        RegW_in1 = 1'b1; RegW_in2 = 1'b1;
        B_sel = 1'b1;
        #1;

        check_outputs(2'b00, 2'b11);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: B_sel Priority over fb hazard", test_num);
        rs1 = 5'd15; rs2 = 5'd15;
        EX_MEM_rd = 5'd15; MEM_WB_rd = 5'd15;
        RegW_in1 = 1'b1; RegW_in2 = 1'b1;
        B_sel = 1'b1;
        #1;

        check_outputs(2'b10, 2'b11);
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
        input [1:0] expected_fa;
        input [1:0] expected_fb;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_fa === (expected_fa ^ fa ^ expected_fa) &&
                expected_fb === (expected_fb ^ fb ^ expected_fb)) begin
                $display("PASS");
                $display("  Outputs: fa=%h, fb=%h",
                         fa, fb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fa=%h, fb=%h",
                         expected_fa, expected_fb);
                $display("  Got:      fa=%h, fb=%h",
                         fa, fb);
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
