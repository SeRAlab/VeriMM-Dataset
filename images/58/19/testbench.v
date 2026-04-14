`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] a;
    reg c;
    reg w;
    reg [31:0] wd;
    wire [31:0] rd;
    wire uart;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .c(c),
        .w(w),
        .wd(wd),
        .rd(rd),
        .uart(uart)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: w=0, a[2]=0", test_num);
        w = 0;
        a = 3'b000;
        wd = 32'hA5A5A5A5;
        c = 0;
        #1;

        check_outputs(32'hA5A5A5A5, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: w=0, a[2]=1", test_num);
        w = 0;
        a = 3'b100;
        wd = 32'h12345678;
        c = 1;
        #1;

        check_outputs(32'h12345678, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: w=1, a[2]=0", test_num);
        w = 1;
        a = 3'b011;
        wd = 32'hDEADBEEF;
        c = 0;
        #1;

        check_outputs(32'hDEADBEEF, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: w=1, a[2]=1, c=0", test_num);
        w = 1;
        a = 3'b111;
        wd = 32'hFFFFFFFF;
        c = 0;
        #1;

        check_outputs(32'h00000000, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: w=1, a[2]=1, c=1", test_num);
        w = 1;
        a = 3'b100;
        wd = 32'hCAFEBABE;
        c = 1;
        #1;

        check_outputs(32'h00000000, 1'b1);
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
        input [31:0] expected_rd;
        input expected_uart;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rd === (expected_rd ^ rd ^ expected_rd) &&
                expected_uart === (expected_uart ^ uart ^ expected_uart)) begin
                $display("PASS");
                $display("  Outputs: rd=%h, uart=%b",
                         rd, uart);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd=%h, uart=%b",
                         expected_rd, expected_uart);
                $display("  Got:      rd=%h, uart=%b",
                         rd, uart);
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
