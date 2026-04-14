`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Branch;
    reg ID2EX_MemRead;
    reg [4:0] ID2EX_Rt;
    reg [4:0] IF2ID_Rs;
    reg [4:0] IF2ID_Rt;
    reg Jump;
    wire ID2EX_flush;
    wire IF2ID_flush;
    wire IF2ID_write;
    wire PCWrite;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Branch(Branch),
        .ID2EX_MemRead(ID2EX_MemRead),
        .ID2EX_Rt(ID2EX_Rt),
        .IF2ID_Rs(IF2ID_Rs),
        .IF2ID_Rt(IF2ID_Rt),
        .Jump(Jump),
        .ID2EX_flush(ID2EX_flush),
        .IF2ID_flush(IF2ID_flush),
        .IF2ID_write(IF2ID_write),
        .PCWrite(PCWrite)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Normal Execution (No Hazards, No Branch/Jump)", test_num);

            ID2EX_MemRead = 0;
            Branch = 0;
            Jump = 0;
            ID2EX_Rt = 5'd5;
            IF2ID_Rs = 5'd10;
            IF2ID_Rt = 5'd11;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Load-Use Hazard (Rs Match)", test_num);

            ID2EX_MemRead = 1;
            Branch = 0;
            Jump = 0;
            ID2EX_Rt = 5'd5;
            IF2ID_Rs = 5'd5;
            IF2ID_Rt = 5'd11;


            #1;



            check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Load-Use Hazard (Rt Match)", test_num);

            ID2EX_MemRead = 1;
            Branch = 0;
            Jump = 0;
            ID2EX_Rt = 5'd8;
            IF2ID_Rs = 5'd10;
            IF2ID_Rt = 5'd8;


            #1;



            check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Jump Control Hazard", test_num);

            ID2EX_MemRead = 0;
            Branch = 0;
            Jump = 1;
            ID2EX_Rt = 5'd5;
            IF2ID_Rs = 5'd10;
            IF2ID_Rt = 5'd11;


            #1;



            check_outputs(1'b0, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Branch Control Hazard", test_num);

            ID2EX_MemRead = 0;
            Branch = 1;
            Jump = 0;
            ID2EX_Rt = 5'd5;
            IF2ID_Rs = 5'd10;
            IF2ID_Rt = 5'd11;


            #1;



            check_outputs(1'b0, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Simultaneous Load-Use and Branch Hazard", test_num);

            ID2EX_MemRead = 1;
            Branch = 1;
            Jump = 0;
            ID2EX_Rt = 5'd5;
            IF2ID_Rs = 5'd5;
            IF2ID_Rt = 5'd11;


            #1;



            check_outputs(1'b1, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: MemRead High but No Register Match", test_num);

            ID2EX_MemRead = 1;
            Branch = 0;
            Jump = 0;
            ID2EX_Rt = 5'd5;
            IF2ID_Rs = 5'd10;
            IF2ID_Rt = 5'd11;


            #1;



            check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
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
        input expected_ID2EX_flush;
        input expected_IF2ID_flush;
        input expected_IF2ID_write;
        input expected_PCWrite;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ID2EX_flush === (expected_ID2EX_flush ^ ID2EX_flush ^ expected_ID2EX_flush) &&
                expected_IF2ID_flush === (expected_IF2ID_flush ^ IF2ID_flush ^ expected_IF2ID_flush) &&
                expected_IF2ID_write === (expected_IF2ID_write ^ IF2ID_write ^ expected_IF2ID_write) &&
                expected_PCWrite === (expected_PCWrite ^ PCWrite ^ expected_PCWrite)) begin
                $display("PASS");
                $display("  Outputs: ID2EX_flush=%b, IF2ID_flush=%b, IF2ID_write=%b, PCWrite=%b",
                         ID2EX_flush, IF2ID_flush, IF2ID_write, PCWrite);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ID2EX_flush=%b, IF2ID_flush=%b, IF2ID_write=%b, PCWrite=%b",
                         expected_ID2EX_flush, expected_IF2ID_flush, expected_IF2ID_write, expected_PCWrite);
                $display("  Got:      ID2EX_flush=%b, IF2ID_flush=%b, IF2ID_write=%b, PCWrite=%b",
                         ID2EX_flush, IF2ID_flush, IF2ID_write, PCWrite);
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
