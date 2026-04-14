`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg cin;
    reg [3:0] op;
    wire cout;
    wire [7:0] y;
    wire zout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .cin(cin),
        .op(op),
        .cout(cout),
        .y(y),
        .zout(zout)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition (10 + 20)", test_num);
        op = 4'd0; a = 8'd10; b = 8'd20; cin = 0;
        #1;

        check_outputs(1'b0, 8'd30, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition Overflow (255 + 1)", test_num);
        op = 4'd0; a = 8'hFF; b = 8'h01; cin = 0;
        #1;

        check_outputs(1'b1, 8'h00, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction (50 - 10)", test_num);
        op = 4'd1; a = 8'd50; b = 8'd10; cin = 0;
        #1;

        check_outputs(1'b0, 8'd40, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction Borrow (10 - 20)", test_num);
        op = 4'd1; a = 8'd10; b = 8'd20; cin = 0;

        #1;


        check_outputs(1'b1, 8'hF6, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise AND (AA & 55)", test_num);
        op = 4'd2; a = 8'hAA; b = 8'h55; cin = 0;
        #1;

        check_outputs(1'b0, 8'h00, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise OR (0F | F0)", test_num);
        op = 4'd3; a = 8'h0F; b = 8'hF0; cin = 0;
        #1;

        check_outputs(1'b0, 8'hFF, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise XOR (CC ^ 33)", test_num);
        op = 4'd4; a = 8'hCC; b = 8'h33; cin = 0;
        #1;

        check_outputs(1'b0, 8'hFF, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Complement (~00)", test_num);
        op = 4'd5; a = 8'h00; b = 8'h00; cin = 0;
        #1;

        check_outputs(1'b0, 8'hFF, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Rotate Left (with cin=1)", test_num);
        op = 4'd6; a = 8'h80; b = 8'h00; cin = 1'b1;
        #1;

        check_outputs(1'b1, 8'h01, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Rotate Right (with cin=1)", test_num);
        op = 4'd7; a = 8'h01; b = 8'h00; cin = 1'b1;
        #1;

        check_outputs(1'b1, 8'h80, 1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Nibble Swap (A5 -> 5A)", test_num);
        op = 4'd8; a = 8'hA5; b = 8'h00; cin = 0;
        #1;

        check_outputs(1'b0, 8'h5A, 1'b0);
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
        input [7:0] expected_y;
        input expected_zout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_y === (expected_y ^ y ^ expected_y) &&
                expected_zout === (expected_zout ^ zout ^ expected_zout)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, y=%h, zout=%b",
                         cout, y, zout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, y=%h, zout=%b",
                         expected_cout, expected_y, expected_zout);
                $display("  Got:      cout=%b, y=%h, zout=%b",
                         cout, y, zout);
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
