`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [123:0] spc_pcx_data_pa;
    reg spc_pcx_data_rdy;
    wire [123:0] spc_pcx_data_buf_pa;
    wire spc_pcx_data_buf_rdy;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .spc_pcx_data_pa(spc_pcx_data_pa),
        .spc_pcx_data_rdy(spc_pcx_data_rdy),
        .spc_pcx_data_buf_pa(spc_pcx_data_buf_pa),
        .spc_pcx_data_buf_rdy(spc_pcx_data_buf_rdy)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: All zeros", test_num);
        spc_pcx_data_pa = 124'h0;
        spc_pcx_data_rdy = 1'b0;
        #1;

        check_outputs(124'h0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Ready high with data pattern", test_num);
        spc_pcx_data_pa = 124'hA5A5A5A5_A5A5A5A5_A5A5A5A5_A5A5A5A;
        spc_pcx_data_rdy = 1'b1;
        #1;

        check_outputs(124'hA5A5A5A5_A5A5A5A5_A5A5A5A5_A5A5A5A, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Ready low with data", test_num);
        spc_pcx_data_pa = 124'h12345678_9ABCDEF0_12345678_9ABCDEF;
        spc_pcx_data_rdy = 1'b0;
        #1;

        check_outputs(124'h12345678_9ABCDEF0_12345678_9ABCDEF, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: All bits high", test_num);
        spc_pcx_data_pa = {124{1'b1}};
        spc_pcx_data_rdy = 1'b1;
        #1;

        check_outputs({124{1'b1}}, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Checkerboard pattern 0xAAA...", test_num);
        spc_pcx_data_pa = 124'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
        spc_pcx_data_rdy = 1'b1;
        #1;

        check_outputs(124'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Checkerboard pattern 0x555...", test_num);
        spc_pcx_data_pa = 124'h5555555555555555555555555555555;
        spc_pcx_data_rdy = 1'b0;
        #1;

        check_outputs(124'h5555555555555555555555555555555, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: Single bit LSB", test_num);
        spc_pcx_data_pa = 124'h1;
        spc_pcx_data_rdy = 1'b1;
        #1;

        check_outputs(124'h1, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTestcase %0d: Single bit MSB", test_num);
        spc_pcx_data_pa = (124'h8 << 120);
        spc_pcx_data_rdy = 1'b1;
        #1;

        check_outputs((124'h8 << 120), 1'b1);
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
        input [123:0] expected_spc_pcx_data_buf_pa;
        input expected_spc_pcx_data_buf_rdy;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_spc_pcx_data_buf_pa === (expected_spc_pcx_data_buf_pa ^ spc_pcx_data_buf_pa ^ expected_spc_pcx_data_buf_pa) &&
                expected_spc_pcx_data_buf_rdy === (expected_spc_pcx_data_buf_rdy ^ spc_pcx_data_buf_rdy ^ expected_spc_pcx_data_buf_rdy)) begin
                $display("PASS");
                $display("  Outputs: spc_pcx_data_buf_pa=%h, spc_pcx_data_buf_rdy=%b",
                         spc_pcx_data_buf_pa, spc_pcx_data_buf_rdy);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: spc_pcx_data_buf_pa=%h, spc_pcx_data_buf_rdy=%b",
                         expected_spc_pcx_data_buf_pa, expected_spc_pcx_data_buf_rdy);
                $display("  Got:      spc_pcx_data_buf_pa=%h, spc_pcx_data_buf_rdy=%b",
                         spc_pcx_data_buf_pa, spc_pcx_data_buf_rdy);
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
