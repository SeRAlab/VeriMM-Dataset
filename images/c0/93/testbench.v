`timescale 1ns/1ps

module TrapDetect_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] ALUResult;
    reg Trap;
    reg TrapCond;
    wire EXC_Tr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    TrapDetect dut (
        .ALUResult(ALUResult),
        .Trap(Trap),
        .TrapCond(TrapCond),
        .EXC_Tr(EXC_Tr)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Trap disabled, Result Zero", test_num);
            Trap = 1'b0;
            TrapCond = 1'b0;
            ALUResult = 32'h00000000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Trap disabled, Result Non-Zero", test_num);
            Trap = 1'b0;
            TrapCond = 1'b1;
            ALUResult = 32'h12345678;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Trap enabled, Cond 0, Result Zero", test_num);
            Trap = 1'b1;
            TrapCond = 1'b0;
            ALUResult = 32'h00000000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Trap enabled, Cond 0, Result Non-Zero", test_num);
            Trap = 1'b1;
            TrapCond = 1'b0;
            ALUResult = 32'hFFFFFFFF;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Trap enabled, Cond 1, Result Zero", test_num);
            Trap = 1'b1;
            TrapCond = 1'b1;
            ALUResult = 32'h00000000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Trap enabled, Cond 1, Result Non-Zero", test_num);
            Trap = 1'b1;
            TrapCond = 1'b1;
            ALUResult = 32'hCAFEBABE;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("TrapDetect Testbench");
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
        input expected_EXC_Tr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_EXC_Tr === (expected_EXC_Tr ^ EXC_Tr ^ expected_EXC_Tr)) begin
                $display("PASS");
                $display("  Outputs: EXC_Tr=%b",
                         EXC_Tr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EXC_Tr=%b",
                         expected_EXC_Tr);
                $display("  Got:      EXC_Tr=%b",
                         EXC_Tr);
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
