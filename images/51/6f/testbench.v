`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Branch;
    reg Zero;
    reg [5:0] instruction;
    reg [31:0] read_data1;
    wire PCSrc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Branch(Branch),
        .Zero(Zero),
        .instruction(instruction),
        .read_data1(read_data1),
        .PCSrc(PCSrc)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Branch=0, Instruction=BEQ, Zero=1", test_num);
        Branch = 1'b0;
        instruction = 6'b000100;
        Zero = 1'b1;
        read_data1 = 32'h00000000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Branch=1, Instruction=BEQ, Zero=1 (Taken)", test_num);
        Branch = 1'b1;
        instruction = 6'b000100;
        Zero = 1'b1;
        read_data1 = 32'h12345678;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Branch=1, Instruction=BEQ, Zero=0 (Not Taken)", test_num);
        Branch = 1'b1;
        instruction = 6'b000100;
        Zero = 1'b0;
        read_data1 = 32'h12345678;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Branch=1, Instruction=BNE, Zero=0 (Taken)", test_num);
        Branch = 1'b1;
        instruction = 6'b000101;
        Zero = 1'b0;
        read_data1 = 32'h00000001;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Branch=1, Instruction=BNE, Zero=1 (Not Taken)", test_num);
        Branch = 1'b1;
        instruction = 6'b000101;
        Zero = 1'b1;
        read_data1 = 32'h00000000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Branch=1, Instruction=BLEZ, Data=0 (Taken)", test_num);
        Branch = 1'b1;
        instruction = 6'b000110;
        Zero = 1'b1;
        read_data1 = 32'h00000000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Branch=1, Instruction=BLEZ, Data=Positive (Not Taken)", test_num);
        Branch = 1'b1;
        instruction = 6'b000110;
        Zero = 1'b0;
        read_data1 = 32'h0000000A;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Branch=1, Instruction=BLEZ, Data=Negative (Taken)", test_num);
        Branch = 1'b1;
        instruction = 6'b000110;
        Zero = 1'b0;
        read_data1 = 32'hFFFFFFFF;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Branch=1, Instruction=BGTZ, Data=Positive (Taken)", test_num);
        Branch = 1'b1;
        instruction = 6'b000111;
        Zero = 1'b0;
        read_data1 = 32'h00000005;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Branch=1, Instruction=BGTZ, Data=0 (Not Taken)", test_num);
        Branch = 1'b1;
        instruction = 6'b000111;
        Zero = 1'b1;
        read_data1 = 32'h00000000;
        #1;

        check_outputs(1'b0);
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
        input expected_PCSrc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_PCSrc === (expected_PCSrc ^ PCSrc ^ expected_PCSrc)) begin
                $display("PASS");
                $display("  Outputs: PCSrc=%b",
                         PCSrc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PCSrc=%b",
                         expected_PCSrc);
                $display("  Got:      PCSrc=%b",
                         PCSrc);
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
