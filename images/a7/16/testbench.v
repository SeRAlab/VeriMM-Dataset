`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg rst;
    reg stall_req_from_ex;
    reg stall_req_from_id;
    reg stall_req_from_if;
    reg stall_req_from_me;
    wire [5:0] stall;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .rst(rst),
        .stall_req_from_ex(stall_req_from_ex),
        .stall_req_from_id(stall_req_from_id),
        .stall_req_from_if(stall_req_from_if),
        .stall_req_from_me(stall_req_from_me),
        .stall(stall)
    );
    task testcase001;

    begin
        $display("Testcase 001: Reset condition");
        test_num = 1;

        rst = 1;
        stall_req_from_if = 0;
        stall_req_from_id = 0;
        stall_req_from_ex = 0;
        stall_req_from_me = 0;
        #10;

        #1;


        check_outputs(6'b000000);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Fetch stage stall request");
        test_num = 2;
        rst = 1; #5; rst = 0;
        stall_req_from_if = 1;
        stall_req_from_id = 0;
        stall_req_from_ex = 0;
        stall_req_from_me = 0;
        #10;

        #1;


        check_outputs(6'b000011);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Decode stage stall request");
        test_num = 3;
        rst = 1; #5; rst = 0;
        stall_req_from_if = 0;
        stall_req_from_id = 1;
        stall_req_from_ex = 0;
        stall_req_from_me = 0;
        #10;

        #1;


        check_outputs(6'b000111);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Execute stage stall request");
        test_num = 4;
        rst = 1; #5; rst = 0;
        stall_req_from_if = 0;
        stall_req_from_id = 0;
        stall_req_from_ex = 1;
        stall_req_from_me = 0;
        #10;

        #1;


        check_outputs(6'b001111);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Memory stage stall request");
        test_num = 5;
        rst = 1; #5; rst = 0;
        stall_req_from_if = 0;
        stall_req_from_id = 0;
        stall_req_from_ex = 0;
        stall_req_from_me = 1;
        #10;

        #1;


        check_outputs(6'b011111);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Multiple requests - Memory Priority");
        test_num = 6;
        rst = 1; #5; rst = 0;

        stall_req_from_if = 1;
        stall_req_from_id = 1;
        stall_req_from_ex = 0;
        stall_req_from_me = 1;
        #10;
        #1;

        check_outputs(6'b011111);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Multiple requests - Execute Priority over ID");
        test_num = 7;
        rst = 1; #5; rst = 0;
        stall_req_from_if = 0;
        stall_req_from_id = 1;
        stall_req_from_ex = 1;
        stall_req_from_me = 0;
        #10;
        #1;

        check_outputs(6'b001111);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: No stall requests");
        test_num = 8;
        rst = 1; #5; rst = 0;
        stall_req_from_if = 0;
        stall_req_from_id = 0;
        stall_req_from_ex = 0;
        stall_req_from_me = 0;
        #10;
        #1;

        check_outputs(6'b000000);
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
        input [5:0] expected_stall;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_stall === (expected_stall ^ stall ^ expected_stall)) begin
                $display("PASS");
                $display("  Outputs: stall=%h",
                         stall);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: stall=%h",
                         expected_stall);
                $display("  Got:      stall=%h",
                         stall);
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
