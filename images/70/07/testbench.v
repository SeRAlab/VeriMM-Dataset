`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [18:0] a;
    reg [7:0] b;
    wire [26:0] p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .p(p)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Multiply 0 by 0", test_num);
        a = 19'd0;
        b = 8'd0;
        #1;

        check_outputs(27'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Multiply Max A by 1", test_num);
        a = 19'h7FFFF;
        b = 8'd1;
        #1;

        check_outputs(27'd524287);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Multiply 1 by Max B", test_num);
        a = 19'd1;
        b = 8'hFF;
        #1;

        check_outputs(27'd255);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Maximum possible inputs (Max A * Max B)", test_num);
        a = 19'h7FFFF;
        b = 8'hFF;
        #1;

        check_outputs(27'd133693185);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Power of 2 (2^10 * 2^5)", test_num);
        a = 19'd1024;
        b = 8'd32;
        #1;

        check_outputs(27'd32768);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Mid-range multiplication", test_num);
        a = 19'd123456;
        b = 8'd123;
        #1;

        check_outputs(27'd15185088);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Maximum A multiplied by 0", test_num);
        a = 19'h7FFFF;
        b = 8'd0;
        #1;

        check_outputs(27'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Small primes (13 * 7)", test_num);
        a = 19'd13;
        b = 8'd7;
        #1;

        check_outputs(27'd91);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: High A with High B", test_num);
        a = 19'd500000;
        b = 8'd250;
        #1;

        check_outputs(27'd125000000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Boundary Max A * 2", test_num);
        a = 19'h7FFFF;
        b = 8'd2;
        #1;

        check_outputs(27'd1048574);
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
        input [26:0] expected_p;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: p=%h",
                         p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p=%h",
                         expected_p);
                $display("  Got:      p=%h",
                         p);
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
