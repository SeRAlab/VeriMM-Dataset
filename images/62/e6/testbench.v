`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ID_EX_MemRead;
    reg [3:0] ID_EX_RegisterRt;
    reg [3:0] IF_ID_RegisterRs;
    reg [3:0] IF_ID_RegisterRt;
    wire IF_ID_Write;
    wire PC_Write;
    wire control_mux;

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
        .control_mux(control_mux)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest %0d: No MemRead (No Hazard)", test_num);

            ID_EX_MemRead = 1'b0;
            ID_EX_RegisterRt = 4'd5;
            IF_ID_RegisterRs = 4'd5;
            IF_ID_RegisterRt = 4'd5;


            #1;



            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest %0d: MemRead but no Register Match", test_num);
            ID_EX_MemRead = 1'b1;
            ID_EX_RegisterRt = 4'd5;
            IF_ID_RegisterRs = 4'd1;
            IF_ID_RegisterRt = 4'd2;


            #1;



            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest %0d: Hazard on Rs", test_num);
            ID_EX_MemRead = 1'b1;
            ID_EX_RegisterRt = 4'd8;
            IF_ID_RegisterRs = 4'd8;
            IF_ID_RegisterRt = 4'd2;


            #1;



            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest %0d: Hazard on Rt", test_num);
            ID_EX_MemRead = 1'b1;
            ID_EX_RegisterRt = 4'd4;
            IF_ID_RegisterRs = 4'd3;
            IF_ID_RegisterRt = 4'd4;


            #1;



            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest %0d: Hazard on both Rs and Rt", test_num);
            ID_EX_MemRead = 1'b1;
            ID_EX_RegisterRt = 4'd10;
            IF_ID_RegisterRs = 4'd10;
            IF_ID_RegisterRt = 4'd10;


            #1;



            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest %0d: Hazard with Register 0", test_num);

            ID_EX_MemRead = 1'b1;
            ID_EX_RegisterRt = 4'd0;
            IF_ID_RegisterRs = 4'd0;
            IF_ID_RegisterRt = 4'd1;


            #1;



            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest %0d: MemRead Toggled Off", test_num);
            ID_EX_MemRead = 1'b0;
            ID_EX_RegisterRt = 4'd7;
            IF_ID_RegisterRs = 4'd7;
            IF_ID_RegisterRt = 4'd2;


            #1;



            check_outputs(1'b1, 1'b1, 1'b0);
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
        input expected_control_mux;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_IF_ID_Write === (expected_IF_ID_Write ^ IF_ID_Write ^ expected_IF_ID_Write) &&
                expected_PC_Write === (expected_PC_Write ^ PC_Write ^ expected_PC_Write) &&
                expected_control_mux === (expected_control_mux ^ control_mux ^ expected_control_mux)) begin
                $display("PASS");
                $display("  Outputs: IF_ID_Write=%b, PC_Write=%b, control_mux=%b",
                         IF_ID_Write, PC_Write, control_mux);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IF_ID_Write=%b, PC_Write=%b, control_mux=%b",
                         expected_IF_ID_Write, expected_PC_Write, expected_control_mux);
                $display("  Got:      IF_ID_Write=%b, PC_Write=%b, control_mux=%b",
                         IF_ID_Write, PC_Write, control_mux);
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
