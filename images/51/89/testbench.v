`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Branch;
    reg [1:0] EX_JumpCtrl;
    reg EX_MemtoReg;
    reg [4:0] EX_WR_out;
    reg [4:0] ID_Rs;
    reg [4:0] ID_Rt;
    wire ID_Flush;
    wire IF_Flush;
    wire IF_Write;
    wire PCWrite;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Branch(Branch),
        .EX_JumpCtrl(EX_JumpCtrl),
        .EX_MemtoReg(EX_MemtoReg),
        .EX_WR_out(EX_WR_out),
        .ID_Rs(ID_Rs),
        .ID_Rt(ID_Rt),
        .ID_Flush(ID_Flush),
        .IF_Flush(IF_Flush),
        .IF_Write(IF_Write),
        .PCWrite(PCWrite)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Normal Operation (No Hazards)", test_num);
        ID_Rs = 5'd1;
        ID_Rt = 5'd2;
        EX_WR_out = 5'd3;
        EX_MemtoReg = 1'b0;
        EX_JumpCtrl = 2'b00;
        Branch = 1'b0;


        #1;



        check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Load-Use Hazard on Rs", test_num);
        ID_Rs = 5'd10;
        ID_Rt = 5'd11;
        EX_WR_out = 5'd10;
        EX_MemtoReg = 1'b1;
        EX_JumpCtrl = 2'b00;
        Branch = 1'b0;


        #1;



        check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Load-Use Hazard on Rt", test_num);
        ID_Rs = 5'd10;
        ID_Rt = 5'd11;
        EX_WR_out = 5'd11;
        EX_MemtoReg = 1'b1;
        EX_JumpCtrl = 2'b00;
        Branch = 1'b0;


        #1;



        check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Control Hazard (Branch Taken)", test_num);
        ID_Rs = 5'd1;
        ID_Rt = 5'd2;
        EX_WR_out = 5'd5;
        EX_MemtoReg = 1'b0;
        EX_JumpCtrl = 2'b00;
        Branch = 1'b1;


        #1;



        check_outputs(1'b1, 1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Control Hazard (Jump Instruction)", test_num);
        ID_Rs = 5'd1;
        ID_Rt = 5'd2;
        EX_WR_out = 5'd5;
        EX_MemtoReg = 1'b0;
        EX_JumpCtrl = 2'b01;
        Branch = 1'b0;


        #1;



        check_outputs(1'b1, 1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Load and ID match but not Load-Use (MemtoReg=0)", test_num);
        ID_Rs = 5'd15;
        ID_Rt = 5'd16;
        EX_WR_out = 5'd15;
        EX_MemtoReg = 1'b0;
        EX_JumpCtrl = 2'b00;
        Branch = 1'b0;

        #1;


        check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Simultaneous Load-Use and Branch (Priority Check)", test_num);
        ID_Rs = 5'd20;
        ID_Rt = 5'd21;
        EX_WR_out = 5'd20;
        EX_MemtoReg = 1'b1;
        EX_JumpCtrl = 2'b00;
        Branch = 1'b1;


        #1;



        check_outputs(1'b1, 1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Load to register 0 (No hazard expected)", test_num);
        ID_Rs = 5'd0;
        ID_Rt = 5'd5;
        EX_WR_out = 5'd0;
        EX_MemtoReg = 1'b1;
        EX_JumpCtrl = 2'b00;
        Branch = 1'b0;



        #1;




        check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
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
        input expected_ID_Flush;
        input expected_IF_Flush;
        input expected_IF_Write;
        input expected_PCWrite;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ID_Flush === (expected_ID_Flush ^ ID_Flush ^ expected_ID_Flush) &&
                expected_IF_Flush === (expected_IF_Flush ^ IF_Flush ^ expected_IF_Flush) &&
                expected_IF_Write === (expected_IF_Write ^ IF_Write ^ expected_IF_Write) &&
                expected_PCWrite === (expected_PCWrite ^ PCWrite ^ expected_PCWrite)) begin
                $display("PASS");
                $display("  Outputs: ID_Flush=%b, IF_Flush=%b, IF_Write=%b, PCWrite=%b",
                         ID_Flush, IF_Flush, IF_Write, PCWrite);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ID_Flush=%b, IF_Flush=%b, IF_Write=%b, PCWrite=%b",
                         expected_ID_Flush, expected_IF_Flush, expected_IF_Write, expected_PCWrite);
                $display("  Got:      ID_Flush=%b, IF_Flush=%b, IF_Write=%b, PCWrite=%b",
                         ID_Flush, IF_Flush, IF_Write, PCWrite);
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
