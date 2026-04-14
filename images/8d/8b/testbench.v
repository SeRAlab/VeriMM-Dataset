`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    wire [31:0] D;
    wire [63:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .D(D),
        .P(P)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 32'd0;
            B = 32'd0;
            $display("Test %0d: Zeros - A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(32'h00000000, 64'h0000000000000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 32'd100;
            B = 32'd0;
            $display("Test %0d: B is Zero - A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(32'd100, 64'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 32'd0;
            B = 32'd100;
            $display("Test %0d: A is Zero - A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(32'hFFFFFF9C, 64'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 32'd50;
            B = 32'd1;
            $display("Test %0d: B is One - A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(32'd49, 64'd50);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 32'd10;
            B = 32'd5;
            $display("Test %0d: Small Positive - A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(32'd5, 64'd50);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 32'd5;
            B = 32'd10;
            $display("Test %0d: Result Negative D - A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(32'hFFFFFFF6, 64'd50);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 32'hFFFFFFFF;
            B = 32'h00000001;
            $display("Test %0d: Max A - A=%h, B=%h", test_num, A, B);
            #1;

            check_outputs(32'hFFFFFFFE, 64'h00000000FFFFFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 32'h00010000;
            B = 32'h00010000;
            $display("Test %0d: Power of 2 - A=%h, B=%h", test_num, A, B);
            #1;

            check_outputs(32'h00000000, 64'h00000000000000000000000100000000);

            #1;


            check_outputs(32'h00000000, 64'h0000000100000000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 32'h12345678;
            B = 32'h00000002;
            $display("Test %0d: Shift Check - A=%h, B=%h", test_num, A, B);
            #1;

            check_outputs(32'h12345676, 64'h000000002468ACF0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 32'hFFFFFFFF;
            B = 32'hFFFFFFFF;
            $display("Test %0d: Max Values - A=%h, B=%h", test_num, A, B);


            #1;



            check_outputs(32'h00000000, 64'hFFFFFFFE00000001);
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
        input [31:0] expected_D;
        input [63:0] expected_P;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_D === (expected_D ^ D ^ expected_D) &&
                expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: D=%h, P=%h",
                         D, P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D=%h, P=%h",
                         expected_D, expected_P);
                $display("  Got:      D=%h, P=%h",
                         D, P);
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
