`timescale 1ns/1ps

module or_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    wire [31:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    or_32bit dut (
        .A(A),
        .B(B),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 32'h00000000;
        B = 32'h00000000;
        $display("Testcase 001: All Zeros");
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 32'hFFFFFFFF;
        B = 32'hFFFFFFFF;
        $display("Testcase 002: All Ones");
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 32'h55555555;
        B = 32'hAAAAAAAA;
        $display("Testcase 003: Alternating bits (Complementary)");
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 32'h12345678;
        B = 32'h00000000;
        $display("Testcase 004: Identity (A | 0)");
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 32'h00000000;
        B = 32'h87654321;
        $display("Testcase 005: Identity (0 | B)");
        #1;

        check_outputs(32'h87654321);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 32'hF0F0F0F0;
        B = 32'h0F0F0F0F;
        $display("Testcase 006: Nibble-wise Complementary");
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 32'hAAAA0000;
        B = 32'h0000BBBB;
        $display("Testcase 007: Upper and Lower Half Merging");
        #1;

        check_outputs(32'hAAAABBBB);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 32'h80000000;
        B = 32'h00000001;
        $display("Testcase 008: MSB and LSB Only");
        #1;

        check_outputs(32'h80000001);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 32'hDEADBEEF;
        B = 32'h12345678;
        $display("Testcase 009: Random Hex Patterns");
        #1;

        check_outputs(32'hDEADBEEF | 32'h12345678);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 32'h11111111;
        B = 32'h22222222;
        $display("Testcase 010: Sparse Bits");
        #1;

        check_outputs(32'h33333333);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("or_32bit Testbench");
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
        input [31:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
