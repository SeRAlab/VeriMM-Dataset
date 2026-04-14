`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] EM_RegRD_i;
    reg EM_RegWrite_i;
    reg [4:0] IE_RegRS_i;
    reg [4:0] IE_RegRT_i;
    reg [4:0] MW_RegRD_i;
    reg MW_RegWrite_i;
    wire [1:0] ForwardA_o;
    wire [1:0] ForwardB_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EM_RegRD_i(EM_RegRD_i),
        .EM_RegWrite_i(EM_RegWrite_i),
        .IE_RegRS_i(IE_RegRS_i),
        .IE_RegRT_i(IE_RegRT_i),
        .MW_RegRD_i(MW_RegRD_i),
        .MW_RegWrite_i(MW_RegWrite_i),
        .ForwardA_o(ForwardA_o),
        .ForwardB_o(ForwardB_o)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: No Hazards", test_num);
            EM_RegWrite_i = 1'b1;
            EM_RegRD_i    = 5'd1;
            MW_RegWrite_i = 1'b1;
            MW_RegRD_i    = 5'd2;
            IE_RegRS_i    = 5'd3;
            IE_RegRT_i    = 5'd4;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: EX Hazard on RS", test_num);
            EM_RegWrite_i = 1'b1;
            EM_RegRD_i    = 5'd5;
            MW_RegWrite_i = 1'b0;
            MW_RegRD_i    = 5'd0;
            IE_RegRS_i    = 5'd5;
            IE_RegRT_i    = 5'd6;
            #1;

            check_outputs(2'b10, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: EX Hazard on RT", test_num);
            EM_RegWrite_i = 1'b1;
            EM_RegRD_i    = 5'd10;
            MW_RegWrite_i = 1'b0;
            MW_RegRD_i    = 5'd0;
            IE_RegRS_i    = 5'd1;
            IE_RegRT_i    = 5'd10;
            #1;

            check_outputs(2'b00, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: MEM Hazard on RS", test_num);
            EM_RegWrite_i = 1'b0;
            EM_RegRD_i    = 5'd2;
            MW_RegWrite_i = 1'b1;
            MW_RegRD_i    = 5'd15;
            IE_RegRS_i    = 5'd15;
            IE_RegRT_i    = 5'd4;
            #1;

            check_outputs(2'b01, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: MEM Hazard on RT", test_num);
            EM_RegWrite_i = 1'b1;
            EM_RegRD_i    = 5'd1;
            MW_RegWrite_i = 1'b1;
            MW_RegRD_i    = 5'd20;
            IE_RegRS_i    = 5'd10;
            IE_RegRT_i    = 5'd20;
            #1;

            check_outputs(2'b00, 2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Double Hazard on RS (EX Priority)", test_num);
            EM_RegWrite_i = 1'b1;
            EM_RegRD_i    = 5'd7;
            MW_RegWrite_i = 1'b1;
            MW_RegRD_i    = 5'd7;
            IE_RegRS_i    = 5'd7;
            IE_RegRT_i    = 5'd8;
            #1;

            check_outputs(2'b10, 2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Double Hazard on RT (EX Priority)", test_num);
            EM_RegWrite_i = 1'b1;
            EM_RegRD_i    = 5'd12;
            MW_RegWrite_i = 1'b1;
            MW_RegRD_i    = 5'd12;
            IE_RegRS_i    = 5'd11;
            IE_RegRT_i    = 5'd12;
            #1;

            check_outputs(2'b00, 2'b10);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Register 0 Check", test_num);
            EM_RegWrite_i = 1'b1;
            EM_RegRD_i    = 5'd0;
            MW_RegWrite_i = 1'b1;
            MW_RegRD_i    = 5'd0;
            IE_RegRS_i    = 5'd0;
            IE_RegRT_i    = 5'd0;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: RegWrite Disabled Check", test_num);
            EM_RegWrite_i = 1'b0;
            EM_RegRD_i    = 5'd5;
            MW_RegWrite_i = 1'b0;
            MW_RegRD_i    = 5'd6;
            IE_RegRS_i    = 5'd5;
            IE_RegRT_i    = 5'd6;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Mixed Stages Hazards", test_num);
            EM_RegWrite_i = 1'b1;
            EM_RegRD_i    = 5'd25;
            MW_RegWrite_i = 1'b1;
            MW_RegRD_i    = 5'd26;
            IE_RegRS_i    = 5'd25;
            IE_RegRT_i    = 5'd26;
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
        input [1:0] expected_ForwardA_o;
        input [1:0] expected_ForwardB_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ForwardA_o === (expected_ForwardA_o ^ ForwardA_o ^ expected_ForwardA_o) &&
                expected_ForwardB_o === (expected_ForwardB_o ^ ForwardB_o ^ expected_ForwardB_o)) begin
                $display("PASS");
                $display("  Outputs: ForwardA_o=%h, ForwardB_o=%h",
                         ForwardA_o, ForwardB_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ForwardA_o=%h, ForwardB_o=%h",
                         expected_ForwardA_o, expected_ForwardB_o);
                $display("  Got:      ForwardA_o=%h, ForwardB_o=%h",
                         ForwardA_o, ForwardB_o);
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
