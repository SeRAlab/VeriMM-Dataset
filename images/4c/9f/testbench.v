`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg EX_MemRead;
    reg [4:0] EX_rt;
    reg [4:0] rs;
    reg [4:0] rt;
    wire Stall;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EX_MemRead(EX_MemRead),
        .EX_rt(EX_rt),
        .rs(rs),
        .rt(rt),
        .Stall(Stall)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: No MemRead, registers match - Expect Stall=0", test_num);
            EX_MemRead = 0;
            EX_rt = 5'd10;
            rs = 5'd10;
            rt = 5'd5;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: MemRead active, EX_rt matches rs - Expect Stall=1", test_num);
            EX_MemRead = 1;
            EX_rt = 5'd10;
            rs = 5'd10;
            rt = 5'd5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: MemRead active, EX_rt matches rt - Expect Stall=1", test_num);
            EX_MemRead = 1;
            EX_rt = 5'd15;
            rs = 5'd10;
            rt = 5'd15;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: MemRead active, EX_rt matches both rs and rt - Expect Stall=1", test_num);
            EX_MemRead = 1;
            EX_rt = 5'd20;
            rs = 5'd20;
            rt = 5'd20;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: MemRead active, no register match - Expect Stall=0", test_num);
            EX_MemRead = 1;
            EX_rt = 5'd30;
            rs = 5'd1;
            rt = 5'd2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: All signals zero - Expect Stall=0", test_num);
            EX_MemRead = 0;
            EX_rt = 5'd0;
            rs = 5'd0;
            rt = 5'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Register 0 hazard check (MemRead active) - Expect Stall=1", test_num);
            EX_MemRead = 1;
            EX_rt = 5'd0;
            rs = 5'd0;
            rt = 5'd1;
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
