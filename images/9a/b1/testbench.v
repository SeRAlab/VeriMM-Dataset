`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] ins;
    wire [63:0] imm_data;
    wire [11:0] imm_data12;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ins(ins),
        .imm_data(imm_data),
        .imm_data12(imm_data12)
    );
    task testcase001;

        begin
            test_num = 1;
            ins = 32'h00A00093;
            #1;

            check_outputs(64'h000000000000000A, 12'h00A);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            ins = 32'hFFF00093;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF, 12'hFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            ins = 32'h02812083;
            #1;

            check_outputs(64'h0000000000000028, 12'h028);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            ins = 32'hFFC12083;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFC, 12'hFFC);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            ins = 32'h0020A223;
            #1;

            check_outputs(64'h0000000000000004, 12'h004);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            ins = 32'hFE20AEC3;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFC, 12'hFFC);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            ins = 32'h00208463;
            #1;

            check_outputs(64'h0000000000000008, 12'h004);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            ins = 32'hFE208CE3;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFF8, 12'hFFC);
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
        input [63:0] expected_imm_data;
        input [11:0] expected_imm_data12;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_imm_data === (expected_imm_data ^ imm_data ^ expected_imm_data) &&
                expected_imm_data12 === (expected_imm_data12 ^ imm_data12 ^ expected_imm_data12)) begin
                $display("PASS");
                $display("  Outputs: imm_data=%h, imm_data12=%h",
                         imm_data, imm_data12);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: imm_data=%h, imm_data12=%h",
                         expected_imm_data, expected_imm_data12);
                $display("  Got:      imm_data=%h, imm_data12=%h",
                         imm_data, imm_data12);
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
