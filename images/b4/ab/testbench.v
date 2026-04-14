`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ALUSrc;
    reg [7:0] Imm_Data;
    reg [7:0] Read_Data;
    wire [7:0] Result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUSrc(ALUSrc),
        .Imm_Data(Imm_Data),
        .Read_Data(Read_Data),
        .Result(Result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            ALUSrc = 1'b0;
            Read_Data = 8'h55;
            Imm_Data = 8'h12;
            $display("Test %0d: ALUSrc=0, Read_Data=0x55, Imm_Data=0x12", test_num);
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            ALUSrc = 1'b1;
            Read_Data = 8'h10;
            Imm_Data = 8'h20;
            $display("Test %0d: ALUSrc=1, Read_Data=0x10, Imm_Data=0x20", test_num);
            #1;

            check_outputs(8'h30);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            ALUSrc = 1'b0;
            Read_Data = 8'hFF;
            Imm_Data = 8'hAA;
            $display("Test %0d: ALUSrc=0, Read_Data=0xFF, Imm_Data=0xAA", test_num);
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            ALUSrc = 1'b1;
            Read_Data = 8'hFF;
            Imm_Data = 8'h01;
            $display("Test %0d: ALUSrc=1, Read_Data=0xFF, Imm_Data=0x01", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            ALUSrc = 1'b1;
            Read_Data = 8'h7F;
            Imm_Data = 8'h80;
            $display("Test %0d: ALUSrc=1, Read_Data=0x7F, Imm_Data=0x80", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            ALUSrc = 1'b1;
            Read_Data = 8'h00;
            Imm_Data = 8'h00;
            $display("Test %0d: ALUSrc=1, All Zeros", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            ALUSrc = 1'b1;
            Read_Data = 8'h10;
            Imm_Data = 8'h05;
            #5;
            ALUSrc = 1'b0;
            $display("Test %0d: ALUSrc toggle 1 -> 0, Read_Data=0x10, Imm_Data=0x05", test_num);
            #1;

            check_outputs(8'h05);
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
        input [7:0] expected_Result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Result === (expected_Result ^ Result ^ expected_Result)) begin
                $display("PASS");
                $display("  Outputs: Result=%h",
                         Result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Result=%h",
                         expected_Result);
                $display("  Got:      Result=%h",
                         Result);
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
