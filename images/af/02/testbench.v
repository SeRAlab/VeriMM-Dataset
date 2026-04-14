`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] branch_in;
    reg sign_flag;
    reg zero_flag;
    wire pc_src;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .branch_in(branch_in),
        .sign_flag(sign_flag),
        .zero_flag(zero_flag),
        .pc_src(pc_src)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: branch_in=000 (No Branch), flags=11", test_num);
        branch_in = 3'b000;
        zero_flag = 1'b1;
        sign_flag = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: branch_in=001 (BEQ), zero_flag=1", test_num);
        branch_in = 3'b001;
        zero_flag = 1'b1;
        sign_flag = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: branch_in=001 (BEQ), zero_flag=0", test_num);
        branch_in = 3'b001;
        zero_flag = 1'b0;
        sign_flag = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: branch_in=010 (BNQ), zero_flag=0", test_num);
        branch_in = 3'b010;
        zero_flag = 1'b0;
        sign_flag = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: branch_in=010 (BNQ), zero_flag=1", test_num);
        branch_in = 3'b010;
        zero_flag = 1'b1;
        sign_flag = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: branch_in=011 (BLT), sign_flag=1", test_num);
        branch_in = 3'b011;
        zero_flag = 1'b0;
        sign_flag = 1'b1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: branch_in=011 (BLT), sign_flag=0", test_num);
        branch_in = 3'b011;
        zero_flag = 1'b0;
        sign_flag = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: branch_in=100 (BGT), sign=0, zero=0", test_num);
        branch_in = 3'b100;
        zero_flag = 1'b0;
        sign_flag = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: branch_in=100 (BGT), sign=1, zero=0", test_num);
        branch_in = 3'b100;
        zero_flag = 1'b0;
        sign_flag = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: branch_in=100 (BGT), sign=0, zero=1", test_num);
        branch_in = 3'b100;
        zero_flag = 1'b1;
        sign_flag = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test %0d: branch_in=111 (Undefined), all flags high", test_num);
        branch_in = 3'b111;
        zero_flag = 1'b1;
        sign_flag = 1'b1;
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
        input expected_pc_src;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pc_src === (expected_pc_src ^ pc_src ^ expected_pc_src)) begin
                $display("PASS");
                $display("  Outputs: pc_src=%b",
                         pc_src);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pc_src=%b",
                         expected_pc_src);
                $display("  Got:      pc_src=%b",
                         pc_src);
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
