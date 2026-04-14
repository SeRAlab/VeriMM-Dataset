`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Branch;
    reg [2:0] Condition;
    reg Less;
    reg Overflow;
    reg RegWrite;
    reg Zero;
    wire BranchValid;
    wire RegWriteValid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Branch(Branch),
        .Condition(Condition),
        .Less(Less),
        .Overflow(Overflow),
        .RegWrite(RegWrite),
        .Zero(Zero),
        .BranchValid(BranchValid),
        .RegWriteValid(RegWriteValid)
    );
    task testcase001;

    begin
        test_num = 1;
        Condition = 3'b000; Zero = 1; Less = 0; Overflow = 0;
        Branch = 1; RegWrite = 1;
        $display("Test %0d: Condition EQ (000), Zero=1", test_num);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        Condition = 3'b000; Zero = 0; Less = 0; Overflow = 0;
        Branch = 1; RegWrite = 1;
        $display("Test %0d: Condition EQ (000), Zero=0", test_num);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        Condition = 3'b001; Zero = 0; Less = 0; Overflow = 0;
        Branch = 1; RegWrite = 1;
        $display("Test %0d: Condition NE (001), Zero=0", test_num);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        Condition = 3'b010; Zero = 0; Less = 1; Overflow = 0;
        Branch = 1; RegWrite = 1;
        $display("Test %0d: Condition LT (010), Less=1", test_num);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        Condition = 3'b011; Zero = 0; Less = 0; Overflow = 0;
        Branch = 1; RegWrite = 1;
        $display("Test %0d: Condition GE (011), Less=0", test_num);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        Condition = 3'b100; Zero = 0; Less = 0; Overflow = 1;
        Branch = 1; RegWrite = 1;
        $display("Test %0d: Condition VO (100), Overflow=1", test_num);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        Condition = 3'b101; Zero = 0; Less = 0; Overflow = 0;
        Branch = 1; RegWrite = 1;
        $display("Test %0d: Condition NV (101), Overflow=0", test_num);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        Condition = 3'b110; Zero = 0; Less = 1; Overflow = 0;
        Branch = 1; RegWrite = 1;
        $display("Test %0d: Condition LE (110), Less=1, Zero=0", test_num);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        Condition = 3'b111; Zero = 0; Less = 0; Overflow = 0;
        Branch = 1; RegWrite = 1;
        $display("Test %0d: Condition GT (111), Less=0, Zero=0", test_num);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        Condition = 3'b000; Zero = 1; Less = 0; Overflow = 0;
        Branch = 0; RegWrite = 1;
        $display("Test %0d: Branch=0 gating", test_num);
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        Condition = 3'b000; Zero = 1; Less = 0; Overflow = 0;
        Branch = 1; RegWrite = 0;
        $display("Test %0d: RegWrite=0 gating", test_num);
        #1;

        check_outputs(1'b1, 1'b0);
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
        testcase009();
        testcase010();
        testcase011();
        
        
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
        input expected_BranchValid;
        input expected_RegWriteValid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_BranchValid === (expected_BranchValid ^ BranchValid ^ expected_BranchValid) &&
                expected_RegWriteValid === (expected_RegWriteValid ^ RegWriteValid ^ expected_RegWriteValid)) begin
                $display("PASS");
                $display("  Outputs: BranchValid=%b, RegWriteValid=%b",
                         BranchValid, RegWriteValid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BranchValid=%b, RegWriteValid=%b",
                         expected_BranchValid, expected_RegWriteValid);
                $display("  Got:      BranchValid=%b, RegWriteValid=%b",
                         BranchValid, RegWriteValid);
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
