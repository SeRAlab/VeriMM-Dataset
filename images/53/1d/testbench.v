`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg en;
    reg rst;
    wire [4:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .en(en),
        .rst(rst),
        .S(S)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset priority test", test_num);

        rst = 1;
        en = 1;
        A = 4'd5;
        B = 4'd3;
        #10;

        #1;


        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic addition test (5 + 3)", test_num);

        rst = 1; #10;
        rst = 0;
        en = 1;
        A = 4'd5;
        B = 4'd3;
        #10;

        #1;


        check_outputs(5'd8);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum sum test (15 + 15)", test_num);

        rst = 1; #10;
        rst = 0;
        en = 1;
        A = 4'd15;
        B = 4'd15;
        #10;

        #1;


        check_outputs(5'd30);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Enable functionality (Hold value)", test_num);

        rst = 1; #10;
        rst = 0;

        en = 1;
        A = 4'd10;
        B = 4'd2;
        #10;

        en = 0;
        A = 4'd1;
        B = 4'd1;
        #10;

        #1;


        check_outputs(5'd12);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero addition test", test_num);

        rst = 1; #10;
        rst = 0;
        en = 1;
        A = 4'd0;
        B = 4'd0;
        #10;

        #1;


        check_outputs(5'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Carry out bit test (8 + 8)", test_num);

        rst = 1; #10;
        rst = 0;
        en = 1;
        A = 4'd8;
        B = 4'd8;
        #10;

        #1;


        check_outputs(5'd16);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Toggle Enable with multiple changes", test_num);

        rst = 1; #10;
        rst = 0;

        en = 1; A = 4'd2; B = 4'd2; #10;

        en = 0; A = 4'd5; B = 4'd5; #10;

        en = 1; A = 4'd6; B = 4'd7; #10;

        #1;


        check_outputs(5'd13);
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
        input [4:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: S=%h",
                         S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h",
                         expected_S);
                $display("  Got:      S=%h",
                         S);
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
