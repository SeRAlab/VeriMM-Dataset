`timescale 1ns/1ps

module multiplier_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    wire [63:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier_32bit dut (
        .A(A),
        .B(B),
        .P(P)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Zero Multiplication (0 * 0)", test_num);
        A = 32'h0000_0000;
        B = 32'h0000_0000;
        #1;

        check_outputs(64'h0000_0000_0000_0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Multiplication by Zero (Max * 0)", test_num);
        A = 32'hFFFF_FFFF;
        B = 32'h0000_0000;
        #1;

        check_outputs(64'h0000_0000_0000_0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Unity Multiplication (1 * 1)", test_num);
        A = 32'h0000_0001;
        B = 32'h0000_0001;
        #1;

        check_outputs(64'h0000_0000_0000_0001);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Identity Property (Value * 1)", test_num);
        A = 32'hA5A5_B6B6;
        B = 32'h0000_0001;
        #1;

        check_outputs(64'h0000_0000_A5A5_B6B6);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Small Unsigned Values (12345 * 67890)", test_num);
        A = 32'd12345;
        B = 32'd67890;
        #1;

        check_outputs(64'd838102050);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Power of 2 (2^16 * 2^15)", test_num);
        A = 32'h0001_0000;
        B = 32'h0000_8000;
        #1;

        check_outputs(64'h0000_0000_8000_0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Maximum Unsigned Multiplication (Max * Max)", test_num);
        A = 32'hFFFF_FFFF;
        B = 32'hFFFF_FFFF;
        #1;

        check_outputs(64'hFFFF_FFFE_0000_0001);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Bit Pattern (0xAAAAAAAA * 0x55555555)", test_num);
        A = 32'hAAAA_AAAA;
        B = 32'h5555_5555;
        #1;

        check_outputs(64'h38E3_8E38_1C71_C712);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Large Product (0x12345678 * 0x87654321)", test_num);
        A = 32'h1234_5678;
        B = 32'h8765_4321;
        #1;

        check_outputs(64'h09A1_10A9_5F69_F678);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Large Hex Product (0xDEADBEEF * 0xCAFEBABE)", test_num);
        A = 32'hDEAD_BEEF;
        B = 32'hCAFE_BABE;
        #1;

        check_outputs(64'hB041_926D_52A0_7726);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier_32bit Testbench");
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
        input [63:0] expected_P;
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
