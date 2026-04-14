`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [7:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .product(product)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplications involving Zero", test_num);
            A = 4'd0; B = 4'd0;
            #1;

            check_outputs(8'd0);

            A = 4'd15; B = 4'd0;
            #1;

            check_outputs(8'd0);

            A = 4'd0; B = 4'd7;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplications involving One", test_num);
            A = 4'd1; B = 4'd1;
            #1;

            check_outputs(8'd1);

            A = 4'd15; B = 4'd1;
            #1;

            check_outputs(8'd15);

            A = 4'd1; B = 4'd10;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Powers of Two (Shift behavior)", test_num);
            A = 4'd2; B = 4'd2;
            #1;

            check_outputs(8'd4);

            A = 4'd4; B = 4'd2;
            #1;

            check_outputs(8'd8);

            A = 4'd8; B = 4'd8;
            #1;

            check_outputs(8'd64);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Values", test_num);
            A = 4'd15; B = 4'd15;
            #1;

            check_outputs(8'd225);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Prime and Odd Numbers", test_num);
            A = 4'd3; B = 4'd5;
            #1;

            check_outputs(8'd15);

            A = 4'd7; B = 4'd11;
            #1;

            check_outputs(8'd77);

            A = 4'd13; B = 4'd13;
            #1;

            check_outputs(8'd169);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern testing (alternating bits)", test_num);
            A = 4'b1010; B = 4'b0101;
            #1;

            check_outputs(8'd50);

            A = 4'b1100; B = 4'b0011;
            #1;

            check_outputs(8'd36);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: General Arithmetic", test_num);
            A = 4'd9; B = 4'd6;
            #1;

            check_outputs(8'd54);

            A = 4'd14; B = 4'd2;
            #1;

            check_outputs(8'd28);

            A = 4'd11; B = 4'd4;
            #1;

            check_outputs(8'd44);
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
        input [7:0] expected_product;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_product === (expected_product ^ product ^ expected_product)) begin
                $display("PASS");
                $display("  Outputs: product=%h",
                         product);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: product=%h",
                         expected_product);
                $display("  Got:      product=%h",
                         product);
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
