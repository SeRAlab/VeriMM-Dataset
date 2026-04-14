`timescale 1ns/1ps

module alu_64bit_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [63:0] B;
    reg [1:0] Op;
    wire [63:0] Result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu_64bit dut (
        .A(A),
        .B(B),
        .Op(Op),
        .Result(Result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Addition", test_num);
            A = 64'h0000_0000_0000_0005;
            B = 64'h0000_0000_0000_000A;
            Op = 2'b00;
            #1;

            check_outputs(64'h0000_0000_0000_000F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition with Overflow/Wrap-around", test_num);
            A = 64'hFFFF_FFFF_FFFF_FFFF;
            B = 64'h0000_0000_0000_0001;
            Op = 2'b00;
            #1;

            check_outputs(64'h0000_0000_0000_0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large Addition", test_num);
            A = 64'h1234_5678_9ABC_DEF0;
            B = 64'h0000_0000_0000_000F;
            Op = 2'b00;
            #1;

            check_outputs(64'h1234_5678_9ABC_DEFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Subtraction", test_num);
            A = 64'h0000_0000_0000_0010;
            B = 64'h0000_0000_0000_0004;
            Op = 2'b01;
            #1;

            check_outputs(64'h0000_0000_0000_000C);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction with Underflow/Wrap-around", test_num);
            A = 64'h0000_0000_0000_0000;
            B = 64'h0000_0000_0000_0001;
            Op = 2'b01;
            #1;

            check_outputs(64'hFFFF_FFFF_FFFF_FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction resulting in Zero", test_num);
            A = 64'hAAAA_BBBB_CCCC_DDDD;
            B = 64'hAAAA_BBBB_CCCC_DDDD;
            Op = 2'b01;
            #1;

            check_outputs(64'h0000_0000_0000_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND - Masking", test_num);
            A = 64'hF0F0_F0F0_F0F0_F0F0;
            B = 64'hFFFF_0000_FFFF_0000;
            Op = 2'b10;
            #1;

            check_outputs(64'hF0F0_0000_F0F0_0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND - All Zeros Result", test_num);
            A = 64'hAAAA_AAAA_AAAA_AAAA;
            B = 64'h5555_5555_5555_5555;
            Op = 2'b10;
            #1;

            check_outputs(64'h0000_0000_0000_0000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND - Identity", test_num);
            A = 64'h1357_9BDF_2468_ACE0;
            B = 64'hFFFF_FFFF_FFFF_FFFF;
            Op = 2'b10;
            #1;

            check_outputs(64'h1357_9BDF_2468_ACE0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition with Zero", test_num);
            A = 64'hDEAF_BEEF_CAFE_BABE;
            B = 64'h0000_0000_0000_0000;
            Op = 2'b00;
            #1;

            check_outputs(64'hDEAF_BEEF_CAFE_BABE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("alu_64bit Testbench");
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
        input [63:0] expected_Result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Result === (expected_Result ^ Result ^ expected_Result)) begin
                $display("PASS");
                $display("  Outputs: Result=%h",
                         Result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Result=%h",
                         expected_Result);
                $display("  Got:      Result=%h",
                         Result);
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
