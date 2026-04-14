`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] PCL_dvcByteEnL2;
    reg [31:0] dofDreg;
    reg [31:0] dvc1L2;
    reg [31:0] dvc2L2;
    wire [3:0] EXE_dvc1ByteCmp;
    wire [3:0] EXE_dvc2ByteCmp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PCL_dvcByteEnL2(PCL_dvcByteEnL2),
        .dofDreg(dofDreg),
        .dvc1L2(dvc1L2),
        .dvc2L2(dvc2L2),
        .EXE_dvc1ByteCmp(EXE_dvc1ByteCmp),
        .EXE_dvc2ByteCmp(EXE_dvc2ByteCmp)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All bytes match, all enabled", test_num);
            PCL_dvcByteEnL2 = 4'b1111;
            dofDreg         = 32'h11223344;
            dvc1L2          = 32'h11223344;
            dvc2L2          = 32'h11223344;
            #1;

            check_outputs(4'hF, 4'hF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All bytes match, none enabled", test_num);
            PCL_dvcByteEnL2 = 4'b0000;
            dofDreg         = 32'hAABBCCDD;
            dvc1L2          = 32'hAABBCCDD;
            dvc2L2          = 32'hAABBCCDD;
            #1;

            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Partial byte matches, all enabled", test_num);
            PCL_dvcByteEnL2 = 4'b1111;
            dofDreg         = 32'h12345678;
            dvc1L2          = 32'h12340000;
            dvc2L2          = 32'hFFFF5678;
            #1;

            check_outputs(4'b1100, 4'b0011);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Interleaved matches with specific enables", test_num);

            PCL_dvcByteEnL2 = 4'b1010;
            dofDreg         = 32'hDEADBEEF;
            dvc1L2          = 32'hDE00BE00;
            dvc2L2          = 32'h00AD00EF;
            #1;

            check_outputs(4'hA, 4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero and Max byte values", test_num);
            PCL_dvcByteEnL2 = 4'b1111;
            dofDreg         = 32'h00FF00FF;
            dvc1L2          = 32'h00000000;
            dvc2L2          = 32'hFFFFFFFF;
            #1;

            check_outputs(4'b1010, 4'b0101);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single byte matching", test_num);
            PCL_dvcByteEnL2 = 4'b0001;
            dofDreg         = 32'h11223344;
            dvc1L2          = 32'h11000044;
            dvc2L2          = 32'h00223300;
            #1;

            check_outputs(4'h1, 4'h0);
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
        input [3:0] expected_EXE_dvc1ByteCmp;
        input [3:0] expected_EXE_dvc2ByteCmp;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_EXE_dvc1ByteCmp === (expected_EXE_dvc1ByteCmp ^ EXE_dvc1ByteCmp ^ expected_EXE_dvc1ByteCmp) &&
                expected_EXE_dvc2ByteCmp === (expected_EXE_dvc2ByteCmp ^ EXE_dvc2ByteCmp ^ expected_EXE_dvc2ByteCmp)) begin
                $display("PASS");
                $display("  Outputs: EXE_dvc1ByteCmp=%h, EXE_dvc2ByteCmp=%h",
                         EXE_dvc1ByteCmp, EXE_dvc2ByteCmp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EXE_dvc1ByteCmp=%h, EXE_dvc2ByteCmp=%h",
                         expected_EXE_dvc1ByteCmp, expected_EXE_dvc2ByteCmp);
                $display("  Got:      EXE_dvc1ByteCmp=%h, EXE_dvc2ByteCmp=%h",
                         EXE_dvc1ByteCmp, EXE_dvc2ByteCmp);
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
