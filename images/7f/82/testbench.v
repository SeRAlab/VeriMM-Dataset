`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] ALU_Result;
    reg [15:0] Mem_Data;
    reg Sel;
    wire [15:0] WB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU_Result(ALU_Result),
        .Mem_Data(Mem_Data),
        .Sel(Sel),
        .WB(WB)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Sel=0, ALU_Result=0x1234, Mem_Data=0xABCD", test_num);
            ALU_Result = 16'h1234;
            Mem_Data = 16'hABCD;
            Sel = 1'b0;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Sel=1, ALU_Result=0x1234, Mem_Data=0xABCD", test_num);
            ALU_Result = 16'h1234;
            Mem_Data = 16'hABCD;
            Sel = 1'b1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Sel=0, ALU_Result=0x0000, Mem_Data=0xFFFF", test_num);
            ALU_Result = 16'h0000;
            Mem_Data = 16'hFFFF;
            Sel = 1'b0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Sel=1, ALU_Result=0xFFFF, Mem_Data=0x0000", test_num);
            ALU_Result = 16'hFFFF;
            Mem_Data = 16'h0000;
            Sel = 1'b1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Sel=0, ALU_Result=0xFFFF, Mem_Data=0x0000", test_num);
            ALU_Result = 16'hFFFF;
            Mem_Data = 16'h0000;
            Sel = 1'b0;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Sel=1, ALU_Result=0x0000, Mem_Data=0xFFFF", test_num);
            ALU_Result = 16'h0000;
            Mem_Data = 16'hFFFF;
            Sel = 1'b1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Sel=0, ALU_Result=0x5555, Mem_Data=0xAAAA", test_num);
            ALU_Result = 16'h5555;
            Mem_Data = 16'hAAAA;
            Sel = 1'b0;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Sel=1, ALU_Result=0x5555, Mem_Data=0xAAAA", test_num);
            ALU_Result = 16'h5555;
            Mem_Data = 16'hAAAA;
            Sel = 1'b1;
            #1;

            check_outputs(16'hAAAA);
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
        input [15:0] expected_WB;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_WB === (expected_WB ^ WB ^ expected_WB)) begin
                $display("PASS");
                $display("  Outputs: WB=%h",
                         WB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: WB=%h",
                         expected_WB);
                $display("  Got:      WB=%h",
                         WB);
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
