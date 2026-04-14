`timescale 1ns/1ps

module Multiplier64_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [63:0] B;
    wire [127:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Multiplier64 dut (
        .A(A),
        .B(B),
        .P(P)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 64'h0;
            B = 64'h0;
            $display("Test Case %03d: 0 x 0", test_num);
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 64'hFFFFFFFFFFFFFFFF;
            B = 64'h0;
            $display("Test Case %03d: Max x 0", test_num);
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 64'h1;
            B = 64'hA5A5A5A55A5A5A5A;
            $display("Test Case %03d: 1 x Identity", test_num);
            #1;

            check_outputs({64'h0, 64'hA5A5A5A55A5A5A5A});
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 64'hFFFFFFFFFFFFFFFF;
            B = 64'h1;
            $display("Test Case %03d: Max x 1", test_num);
            #1;

            check_outputs({64'h0, 64'hFFFFFFFFFFFFFFFF});
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;

            A = 64'h0000000100000000;
            B = 64'h0000000100000000;
            $display("Test Case %03d: Power of 2 (2^32 x 2^32)", test_num);
            #1;

            check_outputs(128'h00000000000000010000000000000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;

            A = 64'hFFFFFFFFFFFFFFFF;
            B = 64'hFFFFFFFFFFFFFFFF;
            $display("Test Case %03d: Max x Max", test_num);
            #1;

            check_outputs(128'hFFFFFFFFFFFFFFFE0000000000000001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;

            A = 64'hFEDCBA9876543210;
            B = 64'h0123456789ABCDEF;
            $display("Test Case %03d: Arbitrary Large Multiplication", test_num);
            #1;

            check_outputs(128'h01210AD1D1C62A8D943EFDF6D1993210);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;

            A = 64'h7FFFFFFFFFFFFFFF;
            B = 64'h2;
            $display("Test Case %03d: Multiply by 2", test_num);
            #1;

            check_outputs(128'h0000000000000000FFFFFFFFFFFFFFFE);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;

            A = 64'h00000000FFFFFFFF;
            B = 64'h00000000FFFFFFFF;
            $display("Test Case %03d: (2^32-1) x (2^32-1)", test_num);
            #1;

            check_outputs(128'h0000000000000000FFFFFFFFFFFFFFFE00000001);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;

            A = 64'd12345;
            B = 64'd67890;
            $display("Test Case %03d: Small Integers (12345 x 67890)", test_num);
            #1;

            check_outputs(128'd838102050);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Multiplier64 Testbench");
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
        input [127:0] expected_P;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
