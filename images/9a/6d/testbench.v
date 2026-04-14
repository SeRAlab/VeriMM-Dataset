`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg memread_EX;
    reg [4:0] rd_EX;
    reg regwrite_EX;
    reg [4:0] rs1_ID;
    reg rs1_valid;
    reg [4:0] rs2_ID;
    reg rs2_valid;
    wire stall;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .memread_EX(memread_EX),
        .rd_EX(rd_EX),
        .regwrite_EX(regwrite_EX),
        .rs1_ID(rs1_ID),
        .rs1_valid(rs1_valid),
        .rs2_ID(rs2_ID),
        .rs2_valid(rs2_valid),
        .stall(stall)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: No matching registers, stall should be 0", test_num);
        rs1_ID = 5'd1;
        rs2_ID = 5'd2;
        rs1_valid = 1'b1;
        rs2_valid = 1'b1;
        rd_EX = 5'd3;
        memread_EX = 1'b1;
        regwrite_EX = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: RS1 match, but memread_EX is low", test_num);
        rs1_ID = 5'd10;
        rs2_ID = 5'd11;
        rs1_valid = 1'b1;
        rs2_valid = 1'b1;
        rd_EX = 5'd10;
        memread_EX = 1'b0;
        regwrite_EX = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: RS1 match, but regwrite_EX is low", test_num);
        rs1_ID = 5'd10;
        rs2_ID = 5'd11;
        rs1_valid = 1'b1;
        rs2_valid = 1'b1;
        rd_EX = 5'd10;
        memread_EX = 1'b1;
        regwrite_EX = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: RS1 match, all conditions met - Stall High", test_num);
        rs1_ID = 5'd15;
        rs2_ID = 5'd20;
        rs1_valid = 1'b1;
        rs2_valid = 1'b1;
        rd_EX = 5'd15;
        memread_EX = 1'b1;
        regwrite_EX = 1'b1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: RS2 match, all conditions met - Stall High", test_num);
        rs1_ID = 5'd15;
        rs2_ID = 5'd20;
        rs1_valid = 1'b1;
        rs2_valid = 1'b1;
        rd_EX = 5'd20;
        memread_EX = 1'b1;
        regwrite_EX = 1'b1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: RS1 match, but rs1_valid is low", test_num);
        rs1_ID = 5'd7;
        rs2_ID = 5'd8;
        rs1_valid = 1'b0;
        rs2_valid = 1'b1;
        rd_EX = 5'd7;
        memread_EX = 1'b1;
        regwrite_EX = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: RS2 match, but rs2_valid is low", test_num);
        rs1_ID = 5'd7;
        rs2_ID = 5'd8;
        rs1_valid = 1'b1;
        rs2_valid = 1'b0;
        rd_EX = 5'd8;
        memread_EX = 1'b1;
        regwrite_EX = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Both RS1 and RS2 match rd_EX", test_num);
        rs1_ID = 5'd4;
        rs2_ID = 5'd4;
        rs1_valid = 1'b1;
        rs2_valid = 1'b1;
        rd_EX = 5'd4;
        memread_EX = 1'b1;
        regwrite_EX = 1'b1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Register 0 check (assuming standard behavior)", test_num);
        rs1_ID = 5'd0;
        rs2_ID = 5'd0;
        rs1_valid = 1'b1;
        rs2_valid = 1'b1;
        rd_EX = 5'd0;
        memread_EX = 1'b1;
        regwrite_EX = 1'b1;

        #1;


        check_outputs(1'b1);
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
        input expected_stall;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_stall === (expected_stall ^ stall ^ expected_stall)) begin
                $display("PASS");
                $display("  Outputs: stall=%b",
                         stall);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: stall=%b",
                         expected_stall);
                $display("  Got:      stall=%b",
                         stall);
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
