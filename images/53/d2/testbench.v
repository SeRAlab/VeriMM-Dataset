`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] rnum;
    wire [7:0] nr_wait_cycle;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .rnum(rnum),
        .nr_wait_cycle(nr_wait_cycle)
    );
    task testcase001;

    begin
        test_num = 1;
        rnum = 32'h0000_0040;
        $display("Test %0d: rnum=%h (lsb8=64)", test_num, rnum);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        rnum = 32'hFFFF_FF20;
        $display("Test %0d: rnum=%h (lsb8=32)", test_num, rnum);
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        rnum = 32'h0000_001F;
        $display("Test %0d: rnum=%h (lsb8=31)", test_num, rnum);
        #1;

        check_outputs(8'h02);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        rnum = 32'h1234_5608;
        $display("Test %0d: rnum=%h (lsb8=8)", test_num, rnum);
        #1;

        check_outputs(8'h03);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        rnum = 32'h0000_0007;
        $display("Test %0d: rnum=%h (lsb8=7)", test_num, rnum);
        #1;

        check_outputs(8'h04);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        rnum = 32'h0000_0002;
        $display("Test %0d: rnum=%h (lsb8=2)", test_num, rnum);
        #1;

        check_outputs(8'h05);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        rnum = 32'hAABB_CC01;
        $display("Test %0d: rnum=%h (lsb8=1)", test_num, rnum);
        #1;

        check_outputs(8'h06);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        rnum = 32'hA500_0000;
        $display("Test %0d: rnum=%h (lsb8=0, upper=A5)", test_num, rnum);
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        rnum = 32'h5A00_0000;
        $display("Test %0d: rnum=%h (lsb8=0, upper=5A)", test_num, rnum);
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        rnum = 32'hFFFF_FFFF;
        $display("Test %0d: rnum=%h (lsb8=255)", test_num, rnum);
        #1;

        check_outputs(8'h00);
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
        input [7:0] expected_nr_wait_cycle;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_nr_wait_cycle === (expected_nr_wait_cycle ^ nr_wait_cycle ^ expected_nr_wait_cycle)) begin
                $display("PASS");
                $display("  Outputs: nr_wait_cycle=%h",
                         nr_wait_cycle);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: nr_wait_cycle=%h",
                         expected_nr_wait_cycle);
                $display("  Got:      nr_wait_cycle=%h",
                         nr_wait_cycle);
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
