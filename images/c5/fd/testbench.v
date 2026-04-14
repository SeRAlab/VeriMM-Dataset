`timescale 1ns/1ps

module binary_to_gray_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    wire [3:0] G;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_to_gray dut (
        .A(A),
        .G(G)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 4'b0000;
            #1;
            $write("Testcase 001: Binary 0000 -> ");
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 4'b0001;
            #1;
            $write("Testcase 002: Binary 0001 -> ");
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 4'b0010;
            #1;
            $write("Testcase 003: Binary 0010 -> ");
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 4'b0011;
            #1;
            $write("Testcase 004: Binary 0011 -> ");
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 4'b0100;
            #1;
            $write("Testcase 005: Binary 0100 -> ");
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 4'b0101;
            #1;
            $write("Testcase 006: Binary 0101 -> ");
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 4'b0110;
            #1;
            $write("Testcase 007: Binary 0110 -> ");
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 4'b0111;
            #1;
            $write("Testcase 008: Binary 0111 -> ");
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 4'b1000;
            #1;
            $write("Testcase 009: Binary 1000 -> ");
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 4'b1001;
            #1;
            $write("Testcase 010: Binary 1001 -> ");
            #1;

            check_outputs(4'b1101);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            A = 4'b1010;
            #1;
            $write("Testcase 011: Binary 1010 -> ");
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            A = 4'b1011;
            #1;
            $write("Testcase 012: Binary 1011 -> ");
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            A = 4'b1100;
            #1;
            $write("Testcase 013: Binary 1100 -> ");
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            A = 4'b1101;
            #1;
            $write("Testcase 014: Binary 1101 -> ");
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            A = 4'b1110;
            #1;
            $write("Testcase 015: Binary 1110 -> ");
            #1;

            check_outputs(4'b1001);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            A = 4'b1111;
            #1;
            $write("Testcase 016: Binary 1111 -> ");
            #1;

            check_outputs(4'b1000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_to_gray Testbench");
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
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [3:0] expected_G;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_G === (expected_G ^ G ^ expected_G)) begin
                $display("PASS");
                $display("  Outputs: G=%h",
                         G);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: G=%h",
                         expected_G);
                $display("  Got:      G=%h",
                         G);
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
