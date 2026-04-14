`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ID_EX_MemRead;
    reg [4:0] ID_EX_RegisterRt;
    reg [4:0] IF_ID_RegisterRs;
    reg [4:0] IF_ID_RegisterRt;
    wire IF_ID_Write;
    wire PC_Write;
    wire data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ID_EX_MemRead(ID_EX_MemRead),
        .ID_EX_RegisterRt(ID_EX_RegisterRt),
        .IF_ID_RegisterRs(IF_ID_RegisterRs),
        .IF_ID_RegisterRt(IF_ID_RegisterRt),
        .IF_ID_Write(IF_ID_Write),
        .PC_Write(PC_Write),
        .data_o(data_o)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Normal Operation (No Load)", test_num);
            ID_EX_MemRead = 1'b0;
            IF_ID_RegisterRs = 5'd1;
            IF_ID_RegisterRt = 5'd2;
            ID_EX_RegisterRt = 5'd1;
            #1;

            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Load Instruction, No Register Match", test_num);
            ID_EX_MemRead = 1'b1;
            IF_ID_RegisterRs = 5'd1;
            IF_ID_RegisterRt = 5'd2;
            ID_EX_RegisterRt = 5'd3;
            #1;

            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Load Hazard on Register Rs", test_num);
            ID_EX_MemRead = 1'b1;
            IF_ID_RegisterRs = 5'd10;
            IF_ID_RegisterRt = 5'd11;
            ID_EX_RegisterRt = 5'd10;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Load Hazard on Register Rt", test_num);
            ID_EX_MemRead = 1'b1;
            IF_ID_RegisterRs = 5'd10;
            IF_ID_RegisterRt = 5'd11;
            ID_EX_RegisterRt = 5'd11;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Load Hazard on Both Registers", test_num);
            ID_EX_MemRead = 1'b1;
            IF_ID_RegisterRs = 5'd15;
            IF_ID_RegisterRt = 5'd15;
            ID_EX_RegisterRt = 5'd15;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Boundary Case - Register Zero", test_num);
            ID_EX_MemRead = 1'b1;
            IF_ID_RegisterRs = 5'd0;
            IF_ID_RegisterRt = 5'd5;
            ID_EX_RegisterRt = 5'd0;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Maximum Register Value Match", test_num);
            ID_EX_MemRead = 1'b1;
            IF_ID_RegisterRs = 5'd31;
            IF_ID_RegisterRt = 5'd0;
            ID_EX_RegisterRt = 5'd31;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
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
        input expected_IF_ID_Write;
        input expected_PC_Write;
        input expected_data_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_IF_ID_Write === (expected_IF_ID_Write ^ IF_ID_Write ^ expected_IF_ID_Write) &&
                expected_PC_Write === (expected_PC_Write ^ PC_Write ^ expected_PC_Write) &&
                expected_data_o === (expected_data_o ^ data_o ^ expected_data_o)) begin
                $display("PASS");
                $display("  Outputs: IF_ID_Write=%b, PC_Write=%b, data_o=%b",
                         IF_ID_Write, PC_Write, data_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IF_ID_Write=%b, PC_Write=%b, data_o=%b",
                         expected_IF_ID_Write, expected_PC_Write, expected_data_o);
                $display("  Got:      IF_ID_Write=%b, PC_Write=%b, data_o=%b",
                         IF_ID_Write, PC_Write, data_o);
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
