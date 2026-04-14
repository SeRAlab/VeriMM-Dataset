`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] AI;
    reg [7:0] BI;
    reg CI;
    reg [1:0] op;
    wire C;
    wire N;
    wire [7:0] OUT;
    wire V;
    wire Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AI(AI),
        .BI(BI),
        .CI(CI),
        .op(op),
        .C(C),
        .N(N),
        .OUT(OUT),
        .V(V),
        .Z(Z)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition Basic (10 + 20 + 0)", test_num);
        op = 2'b00; AI = 8'd10; BI = 8'd20; CI = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0, 8'd30, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition Carry (200 + 100 + 0)", test_num);
        op = 2'b00; AI = 8'd200; BI = 8'd100; CI = 1'b0;


        #1;



        check_outputs(1'b1, 1'b0, 8'd44, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition with CI (5 + 5 + 1)", test_num);
        op = 2'b00; AI = 8'd5; BI = 8'd5; CI = 1'b1;
        #1;

        check_outputs(1'b0, 1'b0, 8'd11, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition Overflow (120 + 10)", test_num);
        op = 2'b00; AI = 8'd120; BI = 8'd10; CI = 1'b0;


        #1;



        check_outputs(1'b0, 1'b1, 8'h82, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction Basic (50 - 20)", test_num);
        op = 2'b01; AI = 8'd50; BI = 8'd20; CI = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0, 8'd30, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction Borrow (10 - 20)", test_num);
        op = 2'b01; AI = 8'd10; BI = 8'd20; CI = 1'b0;

        #1;


        check_outputs(1'b1, 1'b1, 8'hF6, 1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction with CI (20 - 5 - 1)", test_num);
        op = 2'b01; AI = 8'd20; BI = 8'd5; CI = 1'b1;
        #1;

        check_outputs(1'b0, 1'b0, 8'd14, 1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction Overflow (120 - (-10))", test_num);
        op = 2'b01; AI = 8'd120; BI = 8'hF6; CI = 1'b0;


        #1;



        check_outputs(1'b1, 1'b1, 8'h82, 1'b1, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Increment Basic (15 -> 16)", test_num);
        op = 2'b10; AI = 8'd15; BI = 8'd0; CI = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0, 8'd16, 1'b0, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Increment Wrap (255 -> 0)", test_num);
        op = 2'b10; AI = 8'hFF; BI = 8'd0; CI = 1'b0;
        #1;

        check_outputs(1'b1, 1'b0, 8'h00, 1'b0, 1'b1);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Decrement Basic (15 -> 14)", test_num);
        op = 2'b11; AI = 8'd15; BI = 8'd0; CI = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0, 8'd14, 1'b0, 1'b0);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Decrement Wrap (0 -> 255)", test_num);
        op = 2'b11; AI = 8'h00; BI = 8'd0; CI = 1'b0;
        #1;

        check_outputs(1'b1, 1'b1, 8'hFF, 1'b0, 1'b0);
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
        input expected_C;
        input expected_N;
        input [7:0] expected_OUT;
        input expected_V;
        input expected_Z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_N === (expected_N ^ N ^ expected_N) &&
                expected_OUT === (expected_OUT ^ OUT ^ expected_OUT) &&
                expected_V === (expected_V ^ V ^ expected_V) &&
                expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: C=%b, N=%b, OUT=%h, V=%b, Z=%b",
                         C, N, OUT, V, Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%b, N=%b, OUT=%h, V=%b, Z=%b",
                         expected_C, expected_N, expected_OUT, expected_V, expected_Z);
                $display("  Got:      C=%b, N=%b, OUT=%h, V=%b, Z=%b",
                         C, N, OUT, V, Z);
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
