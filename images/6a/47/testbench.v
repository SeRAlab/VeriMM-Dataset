`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg id_ex_memread;
    reg [4:0] id_ex_registerrt;
    reg [4:0] if_id_register_rs;
    reg [4:0] if_id_registerrt;
    wire id_flush_lwstall;
    wire if_id_write;
    wire pcwrite;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .id_ex_memread(id_ex_memread),
        .id_ex_registerrt(id_ex_registerrt),
        .if_id_register_rs(if_id_register_rs),
        .if_id_registerrt(if_id_registerrt),
        .id_flush_lwstall(id_flush_lwstall),
        .if_id_write(if_id_write),
        .pcwrite(pcwrite)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: No Load-Use Hazard (id_ex_memread = 0)", test_num);
            id_ex_memread = 1'b0;
            id_ex_registerrt = 5'd10;
            if_id_register_rs = 5'd10;
            if_id_registerrt = 5'd11;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: No Load-Use Hazard (Registers mismatch)", test_num);
            id_ex_memread = 1'b1;
            id_ex_registerrt = 5'd15;
            if_id_register_rs = 5'd10;
            if_id_registerrt = 5'd11;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Hazard Detected (rs match)", test_num);
            id_ex_memread = 1'b1;
            id_ex_registerrt = 5'd20;
            if_id_register_rs = 5'd20;
            if_id_registerrt = 5'd21;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Hazard Detected (rt match)", test_num);
            id_ex_memread = 1'b1;
            id_ex_registerrt = 5'd25;
            if_id_register_rs = 5'd24;
            if_id_registerrt = 5'd25;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Hazard Detected (rs and rt match)", test_num);
            id_ex_memread = 1'b1;
            id_ex_registerrt = 5'd30;
            if_id_register_rs = 5'd30;
            if_id_registerrt = 5'd30;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Hazard Detected (Register 0 check)", test_num);
            id_ex_memread = 1'b1;
            id_ex_registerrt = 5'd0;
            if_id_register_rs = 5'd0;
            if_id_registerrt = 5'd5;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Clear Stall (id_ex_memread goes low)", test_num);
            id_ex_memread = 1'b0;
            id_ex_registerrt = 5'd25;
            if_id_register_rs = 5'd24;
            if_id_registerrt = 5'd25;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1);
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
        input expected_id_flush_lwstall;
        input expected_if_id_write;
        input expected_pcwrite;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_id_flush_lwstall === (expected_id_flush_lwstall ^ id_flush_lwstall ^ expected_id_flush_lwstall) &&
                expected_if_id_write === (expected_if_id_write ^ if_id_write ^ expected_if_id_write) &&
                expected_pcwrite === (expected_pcwrite ^ pcwrite ^ expected_pcwrite)) begin
                $display("PASS");
                $display("  Outputs: id_flush_lwstall=%b, if_id_write=%b, pcwrite=%b",
                         id_flush_lwstall, if_id_write, pcwrite);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: id_flush_lwstall=%b, if_id_write=%b, pcwrite=%b",
                         expected_id_flush_lwstall, expected_if_id_write, expected_pcwrite);
                $display("  Got:      id_flush_lwstall=%b, if_id_write=%b, pcwrite=%b",
                         id_flush_lwstall, if_id_write, pcwrite);
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
