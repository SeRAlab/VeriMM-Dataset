`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg a_signed;
    reg [31:0] b;
    reg b_signed;
    reg cin;
    reg [2:0] op;
    wire cout;
    wire [31:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .a_signed(a_signed),
        .b(b),
        .b_signed(b_signed),
        .cin(cin),
        .op(op),
        .cout(cout),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Unsigned Addition (5 + 10)", test_num);
        a = 32'd5;
        b = 32'd10;
        a_signed = 0;
        b_signed = 0;
        op = 3'b000;
        cin = 0;
        #1;

        check_outputs(1'b0, 32'd15);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Unsigned Addition with Carry (Max + 1)", test_num);
        a = 32'hFFFFFFFF;
        b = 32'd1;
        a_signed = 0;
        b_signed = 0;
        op = 3'b000;
        cin = 0;
        #1;

        check_outputs(1'b1, 32'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Signed Addition (-1 + -1)", test_num);
        a = 32'hFFFFFFFF;
        b = 32'hFFFFFFFF;
        a_signed = 1;
        b_signed = 1;
        op = 3'b000;
        cin = 0;

        #1;


        check_outputs(1'b1, 32'hFFFFFFFE);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mixed Signed Addition (-5 + 10)", test_num);
        a = 32'hFFFFFFFB;
        b = 32'd10;
        a_signed = 1;
        b_signed = 0;
        op = 3'b000;
        cin = 0;
        #1;

        check_outputs(1'b0, 32'd5);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Unsigned Subtraction (20 - 5)", test_num);
        a = 32'd20;
        b = 32'd5;
        a_signed = 0;
        b_signed = 0;
        op = 3'b001;
        cin = 0;
        #1;

        check_outputs(1'b0, 32'd15);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Unsigned Subtraction with Borrow (5 - 10)", test_num);
        a = 32'd5;
        b = 32'd10;
        a_signed = 0;
        b_signed = 0;
        op = 3'b001;
        cin = 0;

        #1;


        check_outputs(1'b1, 32'hFFFFFFFB);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise AND", test_num);
        a = 32'hF0F0F0F0;
        b = 32'hAAAA5555;
        a_signed = 0;
        b_signed = 0;
        op = 3'b010;
        cin = 0;
        #1;

        check_outputs(1'b0, 32'hA0A05050);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise OR", test_num);
        a = 32'hF0F0F0F0;
        b = 32'hAAAA5555;
        a_signed = 0;
        b_signed = 0;
        op = 3'b011;
        cin = 0;
        #1;

        check_outputs(1'b0, 32'hFAFA55F5);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise XOR", test_num);
        a = 32'h12345678;
        b = 32'h87654321;
        a_signed = 0;
        b_signed = 0;
        op = 3'b100;
        cin = 0;
        #1;

        check_outputs(1'b0, 32'h95511559);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition with Carry-In (10 + 20 + 1)", test_num);
        a = 32'd10;
        b = 32'd20;
        a_signed = 0;
        b_signed = 0;
        op = 3'b000;
        cin = 1;
        #1;

        check_outputs(1'b0, 32'd31);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction with Carry-In (20 - 5 - 1)", test_num);
        a = 32'd20;
        b = 32'd5;
        a_signed = 0;
        b_signed = 0;
        op = 3'b001;
        cin = 1;
        #1;

        check_outputs(1'b0, 32'd14);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Signed Subtraction (-1 - 1)", test_num);
        a = 32'hFFFFFFFF;
        b = 32'd1;
        a_signed = 1;
        b_signed = 1;
        op = 3'b001;
        cin = 0;

        #1;


        check_outputs(1'b1, 32'hFFFFFFFE);
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
        testcase011();
        testcase012();
        
        
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
        input expected_cout;
        input [31:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, sum=%h",
                         cout, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, sum=%h",
                         expected_cout, expected_sum);
                $display("  Got:      cout=%b, sum=%h",
                         cout, sum);
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
