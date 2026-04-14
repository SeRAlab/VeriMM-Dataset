`timescale 1ns/1ps

module calc_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg OP;
    wire [7:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    calc dut (
        .A(A),
        .B(B),
        .OP(OP),
        .C(C)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Simple Addition (10 + 20)", test_num);
        A = 8'd10;
        B = 8'd20;
        OP = 1'b0;
        #1;

        check_outputs(8'd30);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Addition with Zero (55 + 0)", test_num);
        A = 8'd55;
        B = 8'd0;
        OP = 1'b0;
        #1;

        check_outputs(8'd55);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Addition to Max Boundary (128 + 127)", test_num);
        A = 8'd128;
        B = 8'd127;
        OP = 1'b0;
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Simple Subtraction (100 - 40)", test_num);
        A = 8'd100;
        B = 8'd40;
        OP = 1'b1;
        #1;

        check_outputs(8'd60);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Subtraction Resulting in Zero (45 - 45)", test_num);
        A = 8'd45;
        B = 8'd45;
        OP = 1'b1;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Subtraction from Max (255 - 1)", test_num);
        A = 8'd255;
        B = 8'd1;
        OP = 1'b1;
        #1;

        check_outputs(8'd254);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Subtraction of Zero (88 - 0)", test_num);
        A = 8'd88;
        B = 8'd0;
        OP = 1'b1;
        #1;

        check_outputs(8'd88);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Hexadecimal Addition (0x0F + 0xF0)", test_num);
        A = 8'h0F;
        B = 8'hF0;
        OP = 1'b0;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("calc Testbench");
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
        input [7:0] expected_C;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
