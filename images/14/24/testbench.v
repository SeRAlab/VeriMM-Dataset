`timescale 1ns/1ps

module merge_sort_4_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    reg [3:0] d;
    wire [3:0] out0;
    wire [3:0] out1;
    wire [3:0] out2;
    wire [3:0] out3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    merge_sort_4 dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .out0(out0),
        .out1(out1),
        .out2(out2),
        .out3(out3)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Already sorted ascending", test_num);
        a = 4'd1; b = 4'd3; c = 4'd7; d = 4'd12;
        #1;

        check_outputs(4'd1, 4'd3, 4'd7, 4'd12);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Perfectly reversed order", test_num);
        a = 4'd15; b = 4'd10; c = 4'd5; d = 4'd0;
        #1;

        check_outputs(4'd0, 4'd5, 4'd10, 4'd15);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: All inputs identical", test_num);
        a = 4'd8; b = 4'd8; c = 4'd8; d = 4'd8;
        #1;

        check_outputs(4'd8, 4'd8, 4'd8, 4'd8);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Random permutation with duplicates", test_num);
        a = 4'd5; b = 4'd2; c = 4'd5; d = 4'd1;
        #1;

        check_outputs(4'd1, 4'd2, 4'd5, 4'd5);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Minimum and Maximum values", test_num);
        a = 4'd0; b = 4'd15; c = 4'd15; d = 4'd0;
        #1;

        check_outputs(4'd0, 4'd0, 4'd15, 4'd15);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Shifted sequence", test_num);
        a = 4'd14; b = 4'd2; d = 4'd6; c = 4'd10;
        #1;

        check_outputs(4'd2, 4'd6, 4'd10, 4'd14);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Only one value different", test_num);
        a = 4'd3; b = 4'd3; c = 4'd1; d = 4'd3;
        #1;

        check_outputs(4'd1, 4'd3, 4'd3, 4'd3);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: High nibble differences", test_num);
        a = 4'd12; b = 4'd4; c = 4'd8; d = 4'd0;
        #1;

        check_outputs(4'd0, 4'd4, 4'd8, 4'd12);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("merge_sort_4 Testbench");
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
        input [3:0] expected_out0;
        input [3:0] expected_out1;
        input [3:0] expected_out2;
        input [3:0] expected_out3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out0 === (expected_out0 ^ out0 ^ expected_out0) &&
                expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2) &&
                expected_out3 === (expected_out3 ^ out3 ^ expected_out3)) begin
                $display("PASS");
                $display("  Outputs: out0=%h, out1=%h, out2=%h, out3=%h",
                         out0, out1, out2, out3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out0=%h, out1=%h, out2=%h, out3=%h",
                         expected_out0, expected_out1, expected_out2, expected_out3);
                $display("  Got:      out0=%h, out1=%h, out2=%h, out3=%h",
                         out0, out1, out2, out3);
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
