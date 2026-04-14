`timescale 1ns/1ps

module compare_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    compare dut (
        .a(a),
        .b(b),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: a=10, b=5 (a > b, expect difference)", test_num);
        a = 8'd10;
        b = 8'd5;
        #1;

        check_outputs(8'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: a=5, b=10 (b > a, expect sum)", test_num);
        a = 8'd5;
        b = 8'd10;
        #1;

        check_outputs(8'd15);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: a=20, b=20 (a == b, expect difference)", test_num);
        a = 8'd20;
        b = 8'd20;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: a=0, b=0 (zero inputs, a == b)", test_num);
        a = 8'd0;
        b = 8'd0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: a=255, b=0 (a > b, max a)", test_num);
        a = 8'd255;
        b = 8'd0;
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: a=0, b=255 (b > a, max b)", test_num);
        a = 8'd0;
        b = 8'd255;
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: a=128, b=129 (b > a, sum overflow test)", test_num);
        a = 8'd128;
        b = 8'd129;
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: a=255, b=255 (a == b, max values)", test_num);
        a = 8'd255;
        b = 8'd255;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: a=1, b=2 (b > a, small sum)", test_num);
        a = 8'd1;
        b = 8'd2;
        #1;

        check_outputs(8'd3);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: a=200, b=100 (a > b, large values)", test_num);
        a = 8'd200;
        b = 8'd100;
        #1;

        check_outputs(8'd100);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("compare Testbench");
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
        input [7:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
