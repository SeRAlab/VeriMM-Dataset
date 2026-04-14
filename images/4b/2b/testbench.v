`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [48:0] ir;
    reg iralu;
    reg srcq;
    reg state_alu;
    reg state_fetch;
    reg state_mmu;
    reg state_write;
    wire qdrive;
    wire qs0;
    wire qs1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ir(ir),
        .iralu(iralu),
        .srcq(srcq),
        .state_alu(state_alu),
        .state_fetch(state_fetch),
        .state_mmu(state_mmu),
        .state_write(state_write),
        .qdrive(qdrive),
        .qs0(qs0),
        .qs1(qs1)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: All inputs zero", test_num);
        state_alu = 0; state_write = 0; state_mmu = 0; state_fetch = 0;
        ir = 49'h0; iralu = 0; srcq = 0;
        #1;

        check_outputs(0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Testing qdrive with srcq=1 and state_alu=1", test_num);
        state_alu = 1; state_write = 0; state_mmu = 0; state_fetch = 0;
        ir = 49'h0; iralu = 0; srcq = 1;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Testing qdrive with srcq=1 and state_write=1", test_num);
        state_alu = 0; state_write = 1; state_mmu = 0; state_fetch = 0;
        ir = 49'h0; iralu = 0; srcq = 1;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Testing qdrive with srcq=1 and state_mmu=1", test_num);
        state_alu = 0; state_write = 0; state_mmu = 1; state_fetch = 0;
        ir = 49'h0; iralu = 0; srcq = 1;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Testing qdrive with srcq=1 and state_fetch=1", test_num);
        state_alu = 0; state_write = 0; state_mmu = 0; state_fetch = 1;
        ir = 49'h0; iralu = 0; srcq = 1;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Testing qdrive with srcq=0 but all states active", test_num);
        state_alu = 1; state_write = 1; state_mmu = 1; state_fetch = 1;
        ir = 49'h0; iralu = 0; srcq = 0;
        #1;

        check_outputs(0, 0, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Testing qs0 derivation (iralu=1, ir[13]=1)", test_num);
        state_alu = 0; state_write = 0; state_mmu = 0; state_fetch = 0;
        iralu = 1;
        srcq = 0;
        ir = 49'h0;
        ir[13] = 1'b1;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Testing qs1 derivation (iralu=1, ir[14]=1)", test_num);
        state_alu = 0; state_write = 0; state_mmu = 0; state_fetch = 0;
        iralu = 1;
        srcq = 0;
        ir = 49'h0;
        ir[14] = 1'b1;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Testing iralu gate (iralu=0, ir[13:14]=1)", test_num);
        state_alu = 0; state_write = 0; state_mmu = 0; state_fetch = 0;
        iralu = 0;
        srcq = 0;
        ir = 49'h0;
        ir[13] = 1'b1;
        ir[14] = 1'b1;
        #1;

        check_outputs(0, 0, 0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Full system check (all signals high)", test_num);
        state_alu = 1; state_write = 0; state_mmu = 0; state_fetch = 0;
        iralu = 1;
        srcq = 1;
        ir = 49'h0;
        ir[13] = 1'b1;
        ir[14] = 1'b1;
        #1;

        check_outputs(1, 1, 1);
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
        input expected_qdrive;
        input expected_qs0;
        input expected_qs1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_qdrive === (expected_qdrive ^ qdrive ^ expected_qdrive) &&
                expected_qs0 === (expected_qs0 ^ qs0 ^ expected_qs0) &&
                expected_qs1 === (expected_qs1 ^ qs1 ^ expected_qs1)) begin
                $display("PASS");
                $display("  Outputs: qdrive=%b, qs0=%b, qs1=%b",
                         qdrive, qs0, qs1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: qdrive=%b, qs0=%b, qs1=%b",
                         expected_qdrive, expected_qs0, expected_qs1);
                $display("  Got:      qdrive=%b, qs0=%b, qs1=%b",
                         qdrive, qs0, qs1);
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
