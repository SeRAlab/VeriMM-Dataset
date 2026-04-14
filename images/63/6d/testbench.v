`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ID_EX_MEMR_i;
    reg [4:0] ID_EX_RD_i;
    reg [4:0] RS1_i;
    reg [4:0] RS2_i;
    wire BubbleSignal_o;
    wire IF_ID_Write_o;
    wire PCWrite_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ID_EX_MEMR_i(ID_EX_MEMR_i),
        .ID_EX_RD_i(ID_EX_RD_i),
        .RS1_i(RS1_i),
        .RS2_i(RS2_i),
        .BubbleSignal_o(BubbleSignal_o),
        .IF_ID_Write_o(IF_ID_Write_o),
        .PCWrite_o(PCWrite_o)
    );
    task testcase001;

        begin
            $display("Testcase 001: No Memory Read (No Hazard)");
            ID_EX_MEMR_i = 0;
            ID_EX_RD_i = 5'd10;
            RS1_i = 5'd10;
            RS2_i = 5'd11;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Memory Read active, but registers do not match (No Hazard)");
            ID_EX_MEMR_i = 1;
            ID_EX_RD_i = 5'd15;
            RS1_i = 5'd10;
            RS2_i = 5'd11;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Memory Read active, matches RS1 (Hazard Detected)");
            ID_EX_MEMR_i = 1;
            ID_EX_RD_i = 5'd10;
            RS1_i = 5'd10;
            RS2_i = 5'd11;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Memory Read active, matches RS2 (Hazard Detected)");
            ID_EX_MEMR_i = 1;
            ID_EX_RD_i = 5'd20;
            RS1_i = 5'd10;
            RS2_i = 5'd20;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Memory Read active, matches both RS1 and RS2 (Hazard Detected)");
            ID_EX_MEMR_i = 1;
            ID_EX_RD_i = 5'd5;
            RS1_i = 5'd5;
            RS2_i = 5'd5;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Verify edge case with register 0 (Hazard Logic check)");
            ID_EX_MEMR_i = 1;
            ID_EX_RD_i = 5'd0;
            RS1_i = 5'd0;
            RS2_i = 5'd1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Toggle Memory Read with matching registers");
            ID_EX_MEMR_i = 1;
            ID_EX_RD_i = 5'd8;
            RS1_i = 5'd8;
            RS2_i = 5'd2;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);

            ID_EX_MEMR_i = 0;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1);
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
        input expected_BubbleSignal_o;
        input expected_IF_ID_Write_o;
        input expected_PCWrite_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_BubbleSignal_o === (expected_BubbleSignal_o ^ BubbleSignal_o ^ expected_BubbleSignal_o) &&
                expected_IF_ID_Write_o === (expected_IF_ID_Write_o ^ IF_ID_Write_o ^ expected_IF_ID_Write_o) &&
                expected_PCWrite_o === (expected_PCWrite_o ^ PCWrite_o ^ expected_PCWrite_o)) begin
                $display("PASS");
                $display("  Outputs: BubbleSignal_o=%b, IF_ID_Write_o=%b, PCWrite_o=%b",
                         BubbleSignal_o, IF_ID_Write_o, PCWrite_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BubbleSignal_o=%b, IF_ID_Write_o=%b, PCWrite_o=%b",
                         expected_BubbleSignal_o, expected_IF_ID_Write_o, expected_PCWrite_o);
                $display("  Got:      BubbleSignal_o=%b, IF_ID_Write_o=%b, PCWrite_o=%b",
                         BubbleSignal_o, IF_ID_Write_o, PCWrite_o);
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
