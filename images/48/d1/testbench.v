`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] S1_OUTPUT;
    reg [3:0] S2_OUTPUT;
    reg [3:0] S3_OUTPUT;
    reg [3:0] S4_OUTPUT;
    reg [3:0] S5_OUTPUT;
    reg [3:0] S6_OUTPUT;
    reg [3:0] S7_OUTPUT;
    reg [3:0] S8_OUTPUT;
    wire [31:0] S_OUTPUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .S1_OUTPUT(S1_OUTPUT),
        .S2_OUTPUT(S2_OUTPUT),
        .S3_OUTPUT(S3_OUTPUT),
        .S4_OUTPUT(S4_OUTPUT),
        .S5_OUTPUT(S5_OUTPUT),
        .S6_OUTPUT(S6_OUTPUT),
        .S7_OUTPUT(S7_OUTPUT),
        .S8_OUTPUT(S8_OUTPUT),
        .S_OUTPUT(S_OUTPUT)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All Zeros", test_num);
            S1_OUTPUT = 4'h0; S2_OUTPUT = 4'h0; S3_OUTPUT = 4'h0; S4_OUTPUT = 4'h0;
            S5_OUTPUT = 4'h0; S6_OUTPUT = 4'h0; S7_OUTPUT = 4'h0; S8_OUTPUT = 4'h0;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: All Ones", test_num);
            S1_OUTPUT = 4'hF; S2_OUTPUT = 4'hF; S3_OUTPUT = 4'hF; S4_OUTPUT = 4'hF;
            S5_OUTPUT = 4'hF; S6_OUTPUT = 4'hF; S7_OUTPUT = 4'hF; S8_OUTPUT = 4'hF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Sequential Hex Pattern 1-8", test_num);
            S1_OUTPUT = 4'h1; S2_OUTPUT = 4'h2; S3_OUTPUT = 4'h3; S4_OUTPUT = 4'h4;
            S5_OUTPUT = 4'h5; S6_OUTPUT = 4'h6; S7_OUTPUT = 4'h7; S8_OUTPUT = 4'h8;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Sequential Hex Pattern 9-0", test_num);
            S1_OUTPUT = 4'h9; S2_OUTPUT = 4'hA; S3_OUTPUT = 4'hB; S4_OUTPUT = 4'hC;
            S5_OUTPUT = 4'hD; S6_OUTPUT = 4'hE; S7_OUTPUT = 4'hF; S8_OUTPUT = 4'h0;
            #1;

            check_outputs(32'h9ABCDEF0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Alternating A and 5 Pattern", test_num);
            S1_OUTPUT = 4'hA; S2_OUTPUT = 4'h5; S3_OUTPUT = 4'hA; S4_OUTPUT = 4'h5;
            S5_OUTPUT = 4'hA; S6_OUTPUT = 4'h5; S7_OUTPUT = 4'hA; S8_OUTPUT = 4'h5;
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Alternating 5 and A Pattern", test_num);
            S1_OUTPUT = 4'h5; S2_OUTPUT = 4'hA; S3_OUTPUT = 4'h5; S4_OUTPUT = 4'hA;
            S5_OUTPUT = 4'h5; S6_OUTPUT = 4'hA; S7_OUTPUT = 4'h5; S8_OUTPUT = 4'hA;
            #1;

            check_outputs(32'h5A5A5A5A);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Checkerboard Pattern (Bits set)", test_num);
            S1_OUTPUT = 4'b1000; S2_OUTPUT = 4'b0100; S3_OUTPUT = 4'b0010; S4_OUTPUT = 4'b0001;
            S5_OUTPUT = 4'b1000; S6_OUTPUT = 4'b0100; S7_OUTPUT = 4'b0010; S8_OUTPUT = 4'b0001;
            #1;

            check_outputs(32'h84218421);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Random Data Check", test_num);
            S1_OUTPUT = 4'hB; S2_OUTPUT = 4'hE; S3_OUTPUT = 4'hE; S4_OUTPUT = 4'hF;
            S5_OUTPUT = 4'hD; S6_OUTPUT = 4'hE; S7_OUTPUT = 4'hA; S8_OUTPUT = 4'hD;
            #1;

            check_outputs(32'hBEEFDEAD);
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
        input [31:0] expected_S_OUTPUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S_OUTPUT === (expected_S_OUTPUT ^ S_OUTPUT ^ expected_S_OUTPUT)) begin
                $display("PASS");
                $display("  Outputs: S_OUTPUT=%h",
                         S_OUTPUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S_OUTPUT=%h",
                         expected_S_OUTPUT);
                $display("  Got:      S_OUTPUT=%h",
                         S_OUTPUT);
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
