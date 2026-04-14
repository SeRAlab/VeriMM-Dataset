`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg R0W;
    reg [3:0] RA1_EX;
    reg [3:0] RA1_MEM;
    reg [3:0] RA1_WB;
    reg [3:0] RA2_EX;
    reg RegWrite_MEM;
    reg RegWrite_WB;
    wire [1:0] FWD1;
    wire [1:0] FWD2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .R0W(R0W),
        .RA1_EX(RA1_EX),
        .RA1_MEM(RA1_MEM),
        .RA1_WB(RA1_WB),
        .RA2_EX(RA2_EX),
        .RegWrite_MEM(RegWrite_MEM),
        .RegWrite_WB(RegWrite_WB),
        .FWD1(FWD1),
        .FWD2(FWD2)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: No Hazard", test_num);
            RA1_EX = 4'd1; RA2_EX = 4'd2;
            RA1_MEM = 4'd3; RA1_WB = 4'd4;
            RegWrite_MEM = 1'b1; RegWrite_WB = 1'b1;
            R0W = 1'b0;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: EX/MEM Hazard on RA1", test_num);
            RA1_EX = 4'd5; RA2_EX = 4'd2;
            RA1_MEM = 4'd5; RA1_WB = 4'd4;
            RegWrite_MEM = 1'b1; RegWrite_WB = 1'b1;
            R0W = 1'b0;
            #1;

            check_outputs(2'b10, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: MEM/WB Hazard on RA2", test_num);
            RA1_EX = 4'd1; RA2_EX = 4'd6;
            RA1_MEM = 4'd3; RA1_WB = 4'd6;
            RegWrite_MEM = 1'b1; RegWrite_WB = 1'b1;
            R0W = 1'b0;
            #1;

            check_outputs(2'b00, 2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Mixed Stage Hazards", test_num);
            RA1_EX = 4'd7; RA2_EX = 4'd8;
            RA1_MEM = 4'd7; RA1_WB = 4'd8;
            RegWrite_MEM = 1'b1; RegWrite_WB = 1'b1;
            R0W = 1'b0;
            #1;

            check_outputs(2'b10, 2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Priority Test (MEM > WB)", test_num);
            RA1_EX = 4'd10; RA2_EX = 4'd2;
            RA1_MEM = 4'd10; RA1_WB = 4'd10;
            RegWrite_MEM = 1'b1; RegWrite_WB = 1'b1;
            R0W = 1'b0;
            #1;

            check_outputs(2'b10, 2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Match with RegWrite=0", test_num);
            RA1_EX = 4'd12; RA2_EX = 4'd12;
            RA1_MEM = 4'd12; RA1_WB = 4'd12;
            RegWrite_MEM = 1'b0; RegWrite_WB = 1'b0;
            R0W = 1'b0;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: R0 Hazard with R0W=0", test_num);
            RA1_EX = 4'd0; RA2_EX = 4'd0;
            RA1_MEM = 4'd0; RA1_WB = 4'd0;
            RegWrite_MEM = 1'b1; RegWrite_WB = 1'b1;
            R0W = 1'b0;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: R0 Hazard with R0W=1", test_num);
            RA1_EX = 4'd0; RA2_EX = 4'd0;
            RA1_MEM = 4'd0; RA1_WB = 4'd0;
            RegWrite_MEM = 1'b1; RegWrite_WB = 1'b1;
            R0W = 1'b1;
            #1;

            check_outputs(2'b10, 2'b10);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: WB Hazard while MEM writes elsewhere", test_num);
            RA1_EX = 4'd3; RA2_EX = 4'd3;
            RA1_MEM = 4'd15; RA1_WB = 4'd3;
            RegWrite_MEM = 1'b1; RegWrite_WB = 1'b1;
            R0W = 1'b0;
            #1;

            check_outputs(2'b01, 2'b01);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: High Register Address (R15)", test_num);
            RA1_EX = 4'd15; RA2_EX = 4'd15;
            RA1_MEM = 4'd15; RA1_WB = 4'd15;
            RegWrite_MEM = 1'b1; RegWrite_WB = 1'b0;
            R0W = 1'b0;
            #1;

            check_outputs(2'b10, 2'b10);
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
        input [1:0] expected_FWD1;
        input [1:0] expected_FWD2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_FWD1 === (expected_FWD1 ^ FWD1 ^ expected_FWD1) &&
                expected_FWD2 === (expected_FWD2 ^ FWD2 ^ expected_FWD2)) begin
                $display("PASS");
                $display("  Outputs: FWD1=%h, FWD2=%h",
                         FWD1, FWD2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: FWD1=%h, FWD2=%h",
                         expected_FWD1, expected_FWD2);
                $display("  Got:      FWD1=%h, FWD2=%h",
                         FWD1, FWD2);
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
