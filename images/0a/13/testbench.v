`timescale 1ns/1ps

module merge_sort_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    reg [3:0] d;
    wire [3:0] out1;
    wire [3:0] out2;
    wire [3:0] out3;
    wire [3:0] out4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    merge_sort dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .out1(out1),
        .out2(out2),
        .out3(out3),
        .out4(out4)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Already sorted input", test_num);
        a = 4'd1; b = 4'd2; c = 4'd3; d = 4'd4;
        #1;

        check_outputs(4'd1, 4'd2, 4'd3, 4'd4);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reverse sorted input", test_num);
        a = 4'd15; b = 4'd10; c = 4'd5; d = 4'd0;
        #1;

        check_outputs(4'd0, 4'd5, 4'd10, 4'd15);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Random distribution", test_num);
        a = 4'd7; b = 4'd1; d = 4'd12; c = 4'd3;
        #1;

        check_outputs(4'd1, 4'd3, 4'd7, 4'd12);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All same values", test_num);
        a = 4'd9; b = 4'd9; c = 4'd9; d = 4'd9;
        #1;

        check_outputs(4'd9, 4'd9, 4'd9, 4'd9);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Two pairs of duplicates", test_num);
        a = 4'd2; b = 4'd8; c = 4'd2; d = 4'd8;
        #1;

        check_outputs(4'd2, 4'd2, 4'd8, 4'd8);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Three duplicates", test_num);
        a = 4'd5; b = 4'd5; c = 4'd1; d = 4'd5;
        #1;

        check_outputs(4'd1, 4'd5, 4'd5, 4'd5);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Min and Max values", test_num);
        a = 4'd0; b = 4'd15; c = 4'd15; d = 4'd0;
        #1;

        check_outputs(4'd0, 4'd0, 4'd15, 4'd15);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Near-sorted input", test_num);
        a = 4'd2; b = 4'd3; c = 4'd5; d = 4'd4;
        #1;

        check_outputs(4'd2, 4'd3, 4'd4, 4'd5);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shifted order", test_num);
        a = 4'd14; b = 4'd2; c = 4'd4; d = 4'd6;
        #1;

        check_outputs(4'd2, 4'd4, 4'd6, 4'd14);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating high/low", test_num);
        a = 4'd13; b = 4'd1; c = 4'd12; d = 4'd2;
        #1;

        check_outputs(4'd1, 4'd2, 4'd12, 4'd13);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("merge_sort Testbench");
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
        input [3:0] expected_out1;
        input [3:0] expected_out2;
        input [3:0] expected_out3;
        input [3:0] expected_out4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2) &&
                expected_out3 === (expected_out3 ^ out3 ^ expected_out3) &&
                expected_out4 === (expected_out4 ^ out4 ^ expected_out4)) begin
                $display("PASS");
                $display("  Outputs: out1=%h, out2=%h, out3=%h, out4=%h",
                         out1, out2, out3, out4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%h, out2=%h, out3=%h, out4=%h",
                         expected_out1, expected_out2, expected_out3, expected_out4);
                $display("  Got:      out1=%h, out2=%h, out3=%h, out4=%h",
                         out1, out2, out3, out4);
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
