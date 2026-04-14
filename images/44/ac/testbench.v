`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ALUSrc;
    reg [31:0] ReadData2;
    reg [31:0] imm32;
    wire [31:0] ALU_B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUSrc(ALUSrc),
        .ReadData2(ReadData2),
        .imm32(imm32),
        .ALU_B(ALU_B)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ALUSrc=0, Select ReadData2", test_num);
            ALUSrc = 1'b0;
            ReadData2 = 32'hDEADBEEF;
            imm32     = 32'hCAFEBABE;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ALUSrc=1, Select imm32", test_num);
            ALUSrc = 1'b1;
            ReadData2 = 32'hDEADBEEF;
            imm32     = 32'hCAFEBABE;
            #1;

            check_outputs(32'hCAFEBABE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ALUSrc=0, ReadData2=0", test_num);
            ALUSrc = 1'b0;
            ReadData2 = 32'h00000000;
            imm32     = 32'hFFFFFFFF;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ALUSrc=1, imm32=all Fs", test_num);
            ALUSrc = 1'b1;
            ReadData2 = 32'h00000000;
            imm32     = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ALUSrc=0, Alternating patterns", test_num);
            ALUSrc = 1'b0;
            ReadData2 = 32'h5555AAAA;
            imm32     = 32'hAAAA5555;
            #1;

            check_outputs(32'h5555AAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ALUSrc=1, Alternating patterns", test_num);
            ALUSrc = 1'b1;
            ReadData2 = 32'h5555AAAA;
            imm32     = 32'hAAAA5555;
            #1;

            check_outputs(32'hAAAA5555);
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
        input [31:0] expected_ALU_B;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALU_B === (expected_ALU_B ^ ALU_B ^ expected_ALU_B)) begin
                $display("PASS");
                $display("  Outputs: ALU_B=%h",
                         ALU_B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_B=%h",
                         expected_ALU_B);
                $display("  Got:      ALU_B=%h",
                         ALU_B);
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
