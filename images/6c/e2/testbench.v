`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [19:0] a;
    reg [7:0] b;
    wire [27:0] p;

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
        test_num = test_num + 1;
        $display("Test Case %0d: a=0, b=0", test_num);
        a = 20'd0; b = 8'd0;
        #1;

        check_outputs(28'h0000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a=100, b=50", test_num);
        a = 20'd100; b = 8'd50;
        #1;

        check_outputs(28'd5000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a=-100, b=50", test_num);
        a = -20'd100; b = 8'd50;
        #1;

        check_outputs(-28'sd5000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a=MAX_POS, b=255", test_num);
        a = 20'h7FFFF; b = 8'hFF;
        #1;

        check_outputs(28'h7F7FFF1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a=MAX_NEG, b=255", test_num);
        a = 20'h80000; b = 8'hFF;
        #1;

        check_outputs(28'h8080000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a=-1, b=255", test_num);
        a = -20'sd1; b = 8'hFF;
        #1;

        check_outputs(28'hFFFFF01);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a=12345, b=0", test_num);
        a = 20'd12345; b = 8'd0;
        #1;

        check_outputs(28'h0000000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a=-524288, b=1", test_num);
        a = 20'h80000; b = 8'd1;
        #1;

        check_outputs(28'hFF80000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a=1, b=128", test_num);
        a = 20'd1; b = 8'd128;
        #1;

        check_outputs(28'h0000080);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: a=-1, b=1", test_num);
        a = -20'sd1; b = 8'd1;
        #1;

        check_outputs(28'hFFFFFFF);
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
        input [27:0] expected_p;
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
