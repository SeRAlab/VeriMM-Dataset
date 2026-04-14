`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] rd_exmem;
    reg [4:0] rd_memwb;
    reg regwrite_exmem;
    reg regwrite_memwb;
    reg [4:0] rs1_idex;
    reg [4:0] rs2_idex;
    wire [1:0] Forward_A;
    wire [1:0] Forward_B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .rd_exmem(rd_exmem),
        .rd_memwb(rd_memwb),
        .regwrite_exmem(regwrite_exmem),
        .regwrite_memwb(regwrite_memwb),
        .rs1_idex(rs1_idex),
        .rs2_idex(rs2_idex),
        .Forward_A(Forward_A),
        .Forward_B(Forward_B)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: No data hazards", test_num);
            rs1_idex = 5'd1;
            rs2_idex = 5'd2;
            rd_exmem = 5'd3;
            rd_memwb = 5'd4;
            regwrite_exmem = 1'b0;
            regwrite_memwb = 1'b0;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Zero register hazard check", test_num);
            rs1_idex = 5'd0;
            rs2_idex = 5'd0;
            rd_exmem = 5'd0;
            rd_memwb = 5'd0;
            regwrite_exmem = 1'b1;
            regwrite_memwb = 1'b1;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: EX Hazard on rs1", test_num);
            rs1_idex = 5'd10;
            rs2_idex = 5'd5;
            rd_exmem = 5'd10;
            rd_memwb = 5'd20;
            regwrite_exmem = 1'b1;
            regwrite_memwb = 1'b1;
            #1;

            check_outputs(2'b10, 2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: EX Hazard on rs2", test_num);
            rs1_idex = 5'd5;
            rs2_idex = 5'd12;
            rd_exmem = 5'd12;
            rd_memwb = 5'd20;
            regwrite_exmem = 1'b1;
            regwrite_memwb = 1'b1;
            #1;

            check_outputs(2'b00, 2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: MEM Hazard on rs1", test_num);
            rs1_idex = 5'd15;
            rs2_idex = 5'd5;
            rd_exmem = 5'd20;
            rd_memwb = 5'd15;
            regwrite_exmem = 1'b1;
            regwrite_memwb = 1'b1;
            #1;

            check_outputs(2'b01, 2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: MEM Hazard on rs2", test_num);
            rs1_idex = 5'd5;
            rs2_idex = 5'd18;
            rd_exmem = 5'd20;
            rd_memwb = 5'd18;
            regwrite_exmem = 1'b1;
            regwrite_memwb = 1'b1;
            #1;

            check_outputs(2'b00, 2'b01);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Priority Check (EX over MEM)", test_num);
            rs1_idex = 5'd7;
            rs2_idex = 5'd7;
            rd_exmem = 5'd7;
            rd_memwb = 5'd7;
            regwrite_exmem = 1'b1;
            regwrite_memwb = 1'b1;
            #1;

            check_outputs(2'b10, 2'b10);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Mixed hazards (EX rs1, MEM rs2)", test_num);
            rs1_idex = 5'd21;
            rs2_idex = 5'd22;
            rd_exmem = 5'd21;
            rd_memwb = 5'd22;
            regwrite_exmem = 1'b1;
            regwrite_memwb = 1'b1;
            #1;

            check_outputs(2'b10, 2'b01);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("\nTestcase %0d: RegWrite control signal check", test_num);
            rs1_idex = 5'd25;
            rs2_idex = 5'd26;
            rd_exmem = 5'd25;
            rd_memwb = 5'd26;
            regwrite_exmem = 1'b0;
            regwrite_memwb = 1'b0;
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
        input [1:0] expected_Forward_A;
        input [1:0] expected_Forward_B;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Forward_A === (expected_Forward_A ^ Forward_A ^ expected_Forward_A) &&
                expected_Forward_B === (expected_Forward_B ^ Forward_B ^ expected_Forward_B)) begin
                $display("PASS");
                $display("  Outputs: Forward_A=%h, Forward_B=%h",
                         Forward_A, Forward_B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Forward_A=%h, Forward_B=%h",
                         expected_Forward_A, expected_Forward_B);
                $display("  Got:      Forward_A=%h, Forward_B=%h",
                         Forward_A, Forward_B);
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
