`timescale 1ns/1ps

module DWT_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    wire [3:0] c0;
    wire [3:0] c1;
    wire [3:0] d0;
    wire [3:0] d1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DWT dut (
        .a(a),
        .c0(c0),
        .c1(c1),
        .d0(d0),
        .d1(d1)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All inputs zero", test_num);
        a = 4'b0000;
        #1;

        check_outputs(4'd0, 4'd0, 4'd0, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: First pair (a0, a1) both high", test_num);
        a = 4'b0011;


        #1;



        check_outputs(4'd1, 4'd0, 4'd0, 4'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Second pair (a2, a3) both high", test_num);
        a = 4'b1100;


        #1;



        check_outputs(4'd0, 4'd1, 4'd0, 4'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All inputs high", test_num);
        a = 4'b1111;


        #1;



        check_outputs(4'd1, 4'd1, 4'd0, 4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating inputs (Average result 0)", test_num);
        a = 4'b1010;


        #1;



        check_outputs(4'd0, 4'd0, 4'd0, 4'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single bit high (a0)", test_num);
        a = 4'b0001;

        #1;


        check_outputs(4'd0, 4'd0, 4'd0, 4'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Inverted Alternating bits", test_num);
        a = 4'b0101;


        #1;



        check_outputs(4'd0, 4'd0, 4'd0, 4'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DWT Testbench");
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
        input [3:0] expected_c0;
        input [3:0] expected_c1;
        input [3:0] expected_d0;
        input [3:0] expected_d1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c0 === (expected_c0 ^ c0 ^ expected_c0) &&
                expected_c1 === (expected_c1 ^ c1 ^ expected_c1) &&
                expected_d0 === (expected_d0 ^ d0 ^ expected_d0) &&
                expected_d1 === (expected_d1 ^ d1 ^ expected_d1)) begin
                $display("PASS");
                $display("  Outputs: c0=%h, c1=%h, d0=%h, d1=%h",
                         c0, c1, d0, d1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c0=%h, c1=%h, d0=%h, d1=%h",
                         expected_c0, expected_c1, expected_d0, expected_d1);
                $display("  Got:      c0=%h, c1=%h, d0=%h, d1=%h",
                         c0, c1, d0, d1);
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
