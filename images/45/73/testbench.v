`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg MemRead_EX_i;
    reg [4:0] RSaddr_IFID_i;
    reg [4:0] RTaddr_IDEX_i;
    reg [4:0] RTaddr_IFID_i;
    wire ControlReset_EX_o;
    wire ControlReset_ID_o;
    wire PCWrite_o;
    wire WritePipeReg_IFID_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .MemRead_EX_i(MemRead_EX_i),
        .RSaddr_IFID_i(RSaddr_IFID_i),
        .RTaddr_IDEX_i(RTaddr_IDEX_i),
        .RTaddr_IFID_i(RTaddr_IFID_i),
        .ControlReset_EX_o(ControlReset_EX_o),
        .ControlReset_ID_o(ControlReset_ID_o),
        .PCWrite_o(PCWrite_o),
        .WritePipeReg_IFID_o(WritePipeReg_IFID_o)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Normal Operation (MemRead_EX_i = 0)", test_num);
            MemRead_EX_i = 1'b0;
            RSaddr_IFID_i = 5'd10;
            RTaddr_IFID_i = 5'd11;
            RTaddr_IDEX_i = 5'd10;
            #10;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: MemRead High, No Address Match", test_num);
            MemRead_EX_i = 1'b1;
            RSaddr_IFID_i = 5'd10;
            RTaddr_IFID_i = 5'd11;
            RTaddr_IDEX_i = 5'd12;
            #10;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Hazard Detected (RS match)", test_num);
            MemRead_EX_i = 1'b1;
            RSaddr_IFID_i = 5'd15;
            RTaddr_IFID_i = 5'd16;
            RTaddr_IDEX_i = 5'd15;
            #10;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Hazard Detected (RT match)", test_num);
            MemRead_EX_i = 1'b1;
            RSaddr_IFID_i = 5'd20;
            RTaddr_IFID_i = 5'd21;
            RTaddr_IDEX_i = 5'd21;
            #10;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Hazard Detected (Both RS and RT match)", test_num);
            MemRead_EX_i = 1'b1;
            RSaddr_IFID_i = 5'd7;
            RTaddr_IFID_i = 5'd7;
            RTaddr_IDEX_i = 5'd7;
            #10;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Recovery from Stall", test_num);

            MemRead_EX_i = 1'b1;
            RSaddr_IFID_i = 5'd4;
            RTaddr_IDEX_i = 5'd4;
            #10;

            MemRead_EX_i = 1'b0;
            #10;

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
        input expected_ControlReset_EX_o;
        input expected_ControlReset_ID_o;
        input expected_PCWrite_o;
        input expected_WritePipeReg_IFID_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ControlReset_EX_o === (expected_ControlReset_EX_o ^ ControlReset_EX_o ^ expected_ControlReset_EX_o) &&
                expected_ControlReset_ID_o === (expected_ControlReset_ID_o ^ ControlReset_ID_o ^ expected_ControlReset_ID_o) &&
                expected_PCWrite_o === (expected_PCWrite_o ^ PCWrite_o ^ expected_PCWrite_o) &&
                expected_WritePipeReg_IFID_o === (expected_WritePipeReg_IFID_o ^ WritePipeReg_IFID_o ^ expected_WritePipeReg_IFID_o)) begin
                $display("PASS");
                $display("  Outputs: ControlReset_EX_o=%b, ControlReset_ID_o=%b, PCWrite_o=%b, WritePipeReg_IFID_o=%b",
                         ControlReset_EX_o, ControlReset_ID_o, PCWrite_o, WritePipeReg_IFID_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ControlReset_EX_o=%b, ControlReset_ID_o=%b, PCWrite_o=%b, WritePipeReg_IFID_o=%b",
                         expected_ControlReset_EX_o, expected_ControlReset_ID_o, expected_PCWrite_o, expected_WritePipeReg_IFID_o);
                $display("  Got:      ControlReset_EX_o=%b, ControlReset_ID_o=%b, PCWrite_o=%b, WritePipeReg_IFID_o=%b",
                         ControlReset_EX_o, ControlReset_ID_o, PCWrite_o, WritePipeReg_IFID_o);
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
