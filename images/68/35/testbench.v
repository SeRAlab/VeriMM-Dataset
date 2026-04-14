`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg EX_MemRead;
    reg [4:0] EX_rd;
    reg [4:0] ID_rs;
    reg [4:0] ID_rt;
    reg IS_JR;
    reg MEM_MemRead;
    reg [4:0] MEM_rd;
    wire Stall;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EX_MemRead(EX_MemRead),
        .EX_rd(EX_rd),
        .ID_rs(ID_rs),
        .ID_rt(ID_rt),
        .IS_JR(IS_JR),
        .MEM_MemRead(MEM_MemRead),
        .MEM_rd(MEM_rd),
        .Stall(Stall)
    );
    task initialize;

        begin
            EX_MemRead = 0;
            EX_rd = 0;
            ID_rs = 0;
            ID_rt = 0;
            IS_JR = 0;
            MEM_MemRead = 0;
            MEM_rd = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            initialize();
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            initialize();
            EX_MemRead = 1;
            EX_rd = 5'd10;
            ID_rs = 5'd10;
            ID_rt = 5'd5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            initialize();
            EX_MemRead = 1;
            EX_rd = 5'd15;
            ID_rs = 5'd10;
            ID_rt = 5'd15;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            initialize();
            MEM_MemRead = 1;
            MEM_rd = 5'd20;
            ID_rs = 5'd20;
            ID_rt = 5'd10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            initialize();
            MEM_MemRead = 1;
            MEM_rd = 5'd25;
            ID_rs = 5'd5;
            ID_rt = 5'd25;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            initialize();
            EX_MemRead = 0;
            EX_rd = 5'd10;
            ID_rs = 5'd10;
            MEM_MemRead = 0;
            MEM_rd = 5'd10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            initialize();
            IS_JR = 1;
            EX_MemRead = 1;
            EX_rd = 5'd31;
            ID_rs = 5'd31;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            initialize();
            IS_JR = 1;
            MEM_MemRead = 1;
            MEM_rd = 5'd31;
            ID_rs = 5'd31;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            initialize();
            IS_JR = 1;
            EX_MemRead = 1;
            EX_rd = 5'd10;
            ID_rs = 5'd11;
            MEM_MemRead = 1;
            MEM_rd = 5'd12;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            initialize();
            EX_MemRead = 1;
            EX_rd = 5'd0;
            ID_rs = 5'd0;



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
        input expected_Stall;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Stall === (expected_Stall ^ Stall ^ expected_Stall)) begin
                $display("PASS");
                $display("  Outputs: Stall=%b",
                         Stall);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Stall=%b",
                         expected_Stall);
                $display("  Got:      Stall=%b",
                         Stall);
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
