`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [3:0] CTL;
    wire [31:0] OUT;
    wire ZERO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CTL(CTL),
        .OUT(OUT),
        .ZERO(ZERO)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND", test_num);
            CTL = CTL_AND;
            A = 32'hF0F0_F0F0;
            B = 32'hCCCC_CCCC;
            #1;

            check_outputs(32'hC0C0_C0C0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND (Zero Flag)", test_num);
            CTL = CTL_AND;
            A = 32'hAAAA_AAAA;
            B = 32'h5555_5555;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise OR", test_num);
            CTL = CTL_OR;
            A = 32'hAAAA_0000;
            B = 32'h0000_5555;
            #1;

            check_outputs(32'hAAAA_5555, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (Positive)", test_num);
            CTL = CTL_ADD;
            A = 32'd100;
            B = 32'd250;
            #1;

            check_outputs(32'd350, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (Zero Result)", test_num);
            CTL = CTL_ADD;
            A = 32'hFFFF_FFFF;
            B = 32'h0000_0001;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (A > B)", test_num);
            CTL = CTL_SUB;
            A = 32'd500;
            B = 32'd150;
            #1;

            check_outputs(32'd350, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (A == B)", test_num);
            CTL = CTL_SUB;
            A = 32'h1234_5678;
            B = 32'h1234_5678;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SLT (True)", test_num);
            CTL = CTL_SLT;
            A = 32'hFFFF_FFFF;
            B = 32'h0000_0001;
            #1;

            check_outputs(32'h0000_0001, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SLT (False)", test_num);
            CTL = CTL_SLT;
            A = 32'd100;
            B = 32'd50;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise NOR", test_num);
            CTL = CTL_NOR;
            A = 32'h0000_0000;
            B = 32'h0000_0000;
            #1;

            check_outputs(32'hFFFF_FFFF, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise NAND", test_num);
            CTL = CTL_NAND;
            A = 32'hFFFF_FFFF;
            B = 32'hFFFF_FFFF;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
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
        input [31:0] expected_OUT;
        input expected_ZERO;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT) &&
                expected_ZERO === (expected_ZERO ^ ZERO ^ expected_ZERO)) begin
                $display("PASS");
                $display("  Outputs: OUT=%h, ZERO=%b",
                         OUT, ZERO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%h, ZERO=%b",
                         expected_OUT, expected_ZERO);
                $display("  Got:      OUT=%h, ZERO=%b",
                         OUT, ZERO);
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
