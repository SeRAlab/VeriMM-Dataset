`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] X;
    reg [2:0] Y;
    wire C;
    wire [63:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .X(X),
        .Y(Y),
        .C(C),
        .P(P)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Y=001 (P=X, C=0)", test_num);
            X = 64'hA5A5A5A5A5A5A5A5;
            Y = 3'b001;
            #1;

            check_outputs(1'b0, 64'hA5A5A5A5A5A5A5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Y=010 (P=X, C=0)", test_num);
            X = 64'h123456789ABCDEF0;
            Y = 3'b010;
            #1;

            check_outputs(1'b0, 64'h123456789ABCDEF0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Y=011 (P=X << 1, C=0)", test_num);
            X = 64'h0000000000000001;
            Y = 3'b011;
            #1;

            check_outputs(1'b0, 64'h0000000000000002);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Y=011 (P=X << 1, shift into sign)", test_num);
            X = 64'h8000000000000000;
            Y = 3'b011;
            #1;

            check_outputs(1'b0, 64'h0000000000000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Y=100 (P=~(X << 1), C=1)", test_num);
            X = 64'h0000000000000001;
            Y = 3'b100;
            #1;

            check_outputs(1'b1, 64'hFFFFFFFFFFFFFFFD);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Y=101 (P=~X, C=1)", test_num);
            X = 64'h0000000000000000;
            Y = 3'b101;
            #1;

            check_outputs(1'b1, 64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Y=110 (P=~X, C=1)", test_num);
            X = 64'hFFFFFFFFFFFFFFFF;
            Y = 3'b110;
            #1;

            check_outputs(1'b1, 64'h0000000000000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Y=100 (P=~(X << 1) with large X, C=1)", test_num);
            X = 64'h5555555555555555;
            Y = 3'b100;


            #1;



            check_outputs(1'b1, 64'h5555555555555555);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Y=001 (X all ones, P=X, C=0)", test_num);
            X = 64'hFFFFFFFFFFFFFFFF;
            Y = 3'b001;
            #1;

            check_outputs(1'b0, 64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Y=101 (P=~X with pattern, C=1)", test_num);
            X = 64'hAAAAAAAAAAAAAAAA;
            Y = 3'b101;
            #1;

            check_outputs(1'b1, 64'h5555555555555555);
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
        input expected_C;
        input [63:0] expected_P;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: C=%b, P=%h",
                         C, P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%b, P=%h",
                         expected_C, expected_P);
                $display("  Got:      C=%b, P=%h",
                         C, P);
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
