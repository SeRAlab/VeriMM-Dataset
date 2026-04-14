`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] EX_rs;
    reg [4:0] EX_rt;
    reg [4:0] ID_rs;
    reg [4:0] ID_rt;
    reg [4:0] MEM_RW;
    reg MEM_ramwe;
    reg MEM_regwe;
    reg [4:0] MEM_rt;
    reg [4:0] WB_RW;
    reg WB_regwe;
    wire [1:0] EX_forwardA;
    wire [1:0] EX_forwardB;
    wire [1:0] ID_forwardA;
    wire [1:0] ID_forwardB;
    wire MEM_forward;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EX_rs(EX_rs),
        .EX_rt(EX_rt),
        .ID_rs(ID_rs),
        .ID_rt(ID_rt),
        .MEM_RW(MEM_RW),
        .MEM_ramwe(MEM_ramwe),
        .MEM_regwe(MEM_regwe),
        .MEM_rt(MEM_rt),
        .WB_RW(WB_RW),
        .WB_regwe(WB_regwe),
        .EX_forwardA(EX_forwardA),
        .EX_forwardB(EX_forwardB),
        .ID_forwardA(ID_forwardA),
        .ID_forwardB(ID_forwardB),
        .MEM_forward(MEM_forward)
    );
    task reset_inputs;

        begin
            ID_rs = 5'd0;
            ID_rt = 5'd0;
            EX_rs = 5'd0;
            EX_rt = 5'd0;
            MEM_rt = 5'd0;
            MEM_ramwe = 1'b0;
            MEM_regwe = 1'b0;
            WB_regwe = 1'b0;
            MEM_RW = 5'd0;
            WB_RW = 5'd0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: No forwarding", test_num);
            reset_inputs();
            ID_rs = 5'd1; ID_rt = 5'd2;
            EX_rs = 5'd3; EX_rt = 5'd4;
            MEM_RW = 5'd5; MEM_regwe = 1'b1;
            WB_RW = 5'd6; WB_regwe = 1'b1;
            #1;

            check_outputs(2'b00, 2'b00, 2'b00, 2'b00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: EX stage MEM hazard (RS)", test_num);
            reset_inputs();
            EX_rs = 5'd10;
            MEM_RW = 5'd10;
            MEM_regwe = 1'b1;
            #1;

            check_outputs(2'b10, 2'b00, 2'b00, 2'b00, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: EX stage MEM hazard (RT)", test_num);
            reset_inputs();
            EX_rt = 5'd11;
            MEM_RW = 5'd11;
            MEM_regwe = 1'b1;
            #1;

            check_outputs(2'b00, 2'b10, 2'b00, 2'b00, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: EX stage WB hazard (RS)", test_num);
            reset_inputs();
            EX_rs = 5'd12;
            WB_RW = 5'd12;
            WB_regwe = 1'b1;
            #1;

            check_outputs(2'b01, 2'b00, 2'b00, 2'b00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: EX stage Priority check (MEM over WB)", test_num);
            reset_inputs();
            EX_rs = 5'd15;
            MEM_RW = 5'd15;
            MEM_regwe = 1'b1;
            WB_RW = 5'd15;
            WB_regwe = 1'b1;
            #1;

            check_outputs(2'b10, 2'b00, 2'b00, 2'b00, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: ID stage MEM hazard (RS)", test_num);
            reset_inputs();
            ID_rs = 5'd20;
            MEM_RW = 5'd20;
            MEM_regwe = 1'b1;
            #1;

            check_outputs(2'b00, 2'b00, 2'b10, 2'b00, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: ID stage WB hazard (RT)", test_num);
            reset_inputs();
            ID_rt = 5'd21;
            WB_RW = 5'd21;
            WB_regwe = 1'b1;
            #1;

            check_outputs(2'b00, 2'b00, 2'b00, 2'b01, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Register $0 hazard check", test_num);
            reset_inputs();
            EX_rs = 5'd0;
            MEM_RW = 5'd0;
            MEM_regwe = 1'b1;
            #1;

            check_outputs(2'b00, 2'b00, 2'b00, 2'b00, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: MEM stage forwarding (Store Word hazard)", test_num);
            reset_inputs();
            MEM_rt = 5'd25;
            MEM_ramwe = 1'b1;
            WB_RW = 5'd25;
            WB_regwe = 1'b1;
            #1;

            check_outputs(2'b00, 2'b00, 2'b00, 2'b00, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Complex multiple hazard scenario", test_num);
            reset_inputs();

            EX_rs = 5'd5;
            WB_RW = 5'd5;
            WB_regwe = 1'b1;

            EX_rt = 5'd6;
            MEM_RW = 5'd6;
            MEM_regwe = 1'b1;

            ID_rs = 5'd6;

            MEM_rt = 5'd5;
            MEM_ramwe = 1'b1;

            #1;


            check_outputs(2'b01, 2'b10, 2'b10, 2'b00, 1'b1);
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
        input [1:0] expected_EX_forwardA;
        input [1:0] expected_EX_forwardB;
        input [1:0] expected_ID_forwardA;
        input [1:0] expected_ID_forwardB;
        input expected_MEM_forward;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_EX_forwardA === (expected_EX_forwardA ^ EX_forwardA ^ expected_EX_forwardA) &&
                expected_EX_forwardB === (expected_EX_forwardB ^ EX_forwardB ^ expected_EX_forwardB) &&
                expected_ID_forwardA === (expected_ID_forwardA ^ ID_forwardA ^ expected_ID_forwardA) &&
                expected_ID_forwardB === (expected_ID_forwardB ^ ID_forwardB ^ expected_ID_forwardB) &&
                expected_MEM_forward === (expected_MEM_forward ^ MEM_forward ^ expected_MEM_forward)) begin
                $display("PASS");
                $display("  Outputs: EX_forwardA=%h, EX_forwardB=%h, ID_forwardA=%h, ID_forwardB=%h, MEM_forward=%b",
                         EX_forwardA, EX_forwardB, ID_forwardA, ID_forwardB, MEM_forward);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EX_forwardA=%h, EX_forwardB=%h, ID_forwardA=%h, ID_forwardB=%h, MEM_forward=%b",
                         expected_EX_forwardA, expected_EX_forwardB, expected_ID_forwardA, expected_ID_forwardB, expected_MEM_forward);
                $display("  Got:      EX_forwardA=%h, EX_forwardB=%h, ID_forwardA=%h, ID_forwardB=%h, MEM_forward=%b",
                         EX_forwardA, EX_forwardB, ID_forwardA, ID_forwardB, MEM_forward);
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
