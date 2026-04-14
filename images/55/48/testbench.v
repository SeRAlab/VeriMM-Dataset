`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [47:0] EXPANSION_PERMUTATION;
    reg [47:0] SUBKEY;
    wire [5:0] SBOX1_INPUT;
    wire [5:0] SBOX2_INPUT;
    wire [5:0] SBOX3_INPUT;
    wire [5:0] SBOX4_INPUT;
    wire [5:0] SBOX5_INPUT;
    wire [5:0] SBOX6_INPUT;
    wire [5:0] SBOX7_INPUT;
    wire [5:0] SBOX8_INPUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EXPANSION_PERMUTATION(EXPANSION_PERMUTATION),
        .SUBKEY(SUBKEY),
        .SBOX1_INPUT(SBOX1_INPUT),
        .SBOX2_INPUT(SBOX2_INPUT),
        .SBOX3_INPUT(SBOX3_INPUT),
        .SBOX4_INPUT(SBOX4_INPUT),
        .SBOX5_INPUT(SBOX5_INPUT),
        .SBOX6_INPUT(SBOX6_INPUT),
        .SBOX7_INPUT(SBOX7_INPUT),
        .SBOX8_INPUT(SBOX8_INPUT)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            EXPANSION_PERMUTATION = 48'h000000000000;
            SUBKEY = 48'h000000000000;

            #1;


            check_outputs(6'h00, 6'h00, 6'h00, 6'h00, 6'h00, 6'h00, 6'h00, 6'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones XORed with All Ones", test_num);
            EXPANSION_PERMUTATION = 48'hFFFFFFFFFFFF;
            SUBKEY = 48'hFFFFFFFFFFFF;

            #1;


            check_outputs(6'h00, 6'h00, 6'h00, 6'h00, 6'h00, 6'h00, 6'h00, 6'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones XORed with All Zeros", test_num);
            EXPANSION_PERMUTATION = 48'hFFFFFFFFFFFF;
            SUBKEY = 48'h000000000000;

            #1;


            check_outputs(6'h3F, 6'h3F, 6'h3F, 6'h3F, 6'h3F, 6'h3F, 6'h3F, 6'h3F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checkerboard Pattern", test_num);
            EXPANSION_PERMUTATION = 48'hAAAAAAAAAAAAAAAA;
            SUBKEY = 48'h555555555555;

            #1;


            check_outputs(6'h3F, 6'h3F, 6'h3F, 6'h3F, 6'h3F, 6'h3F, 6'h3F, 6'h3F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern Test 1", test_num);


            EXPANSION_PERMUTATION = 48'h123456789ABC;
            SUBKEY = 48'hCBA987654321;
            #1;

            check_outputs(6'h36, 6'h19, 6'h37, 6'h11, 6'h07, 6'h1D, 6'h26, 6'h1D);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating S-Box values", test_num);




            EXPANSION_PERMUTATION = 48'h56A56A56A56A;
            SUBKEY = 48'h000000000000;
            #1;

            check_outputs(6'h15, 6'h2A, 6'h15, 6'h2A, 6'h15, 6'h2A, 6'h15, 6'h2A);
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
        input [5:0] expected_SBOX1_INPUT;
        input [5:0] expected_SBOX2_INPUT;
        input [5:0] expected_SBOX3_INPUT;
        input [5:0] expected_SBOX4_INPUT;
        input [5:0] expected_SBOX5_INPUT;
        input [5:0] expected_SBOX6_INPUT;
        input [5:0] expected_SBOX7_INPUT;
        input [5:0] expected_SBOX8_INPUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_SBOX1_INPUT === (expected_SBOX1_INPUT ^ SBOX1_INPUT ^ expected_SBOX1_INPUT) &&
                expected_SBOX2_INPUT === (expected_SBOX2_INPUT ^ SBOX2_INPUT ^ expected_SBOX2_INPUT) &&
                expected_SBOX3_INPUT === (expected_SBOX3_INPUT ^ SBOX3_INPUT ^ expected_SBOX3_INPUT) &&
                expected_SBOX4_INPUT === (expected_SBOX4_INPUT ^ SBOX4_INPUT ^ expected_SBOX4_INPUT) &&
                expected_SBOX5_INPUT === (expected_SBOX5_INPUT ^ SBOX5_INPUT ^ expected_SBOX5_INPUT) &&
                expected_SBOX6_INPUT === (expected_SBOX6_INPUT ^ SBOX6_INPUT ^ expected_SBOX6_INPUT) &&
                expected_SBOX7_INPUT === (expected_SBOX7_INPUT ^ SBOX7_INPUT ^ expected_SBOX7_INPUT) &&
                expected_SBOX8_INPUT === (expected_SBOX8_INPUT ^ SBOX8_INPUT ^ expected_SBOX8_INPUT)) begin
                $display("PASS");
                $display("  Outputs: SBOX1_INPUT=%h, SBOX2_INPUT=%h, SBOX3_INPUT=%h, SBOX4_INPUT=%h, SBOX5_INPUT=%h, SBOX6_INPUT=%h, SBOX7_INPUT=%h, SBOX8_INPUT=%h",
                         SBOX1_INPUT, SBOX2_INPUT, SBOX3_INPUT, SBOX4_INPUT, SBOX5_INPUT, SBOX6_INPUT, SBOX7_INPUT, SBOX8_INPUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SBOX1_INPUT=%h, SBOX2_INPUT=%h, SBOX3_INPUT=%h, SBOX4_INPUT=%h, SBOX5_INPUT=%h, SBOX6_INPUT=%h, SBOX7_INPUT=%h, SBOX8_INPUT=%h",
                         expected_SBOX1_INPUT, expected_SBOX2_INPUT, expected_SBOX3_INPUT, expected_SBOX4_INPUT, expected_SBOX5_INPUT, expected_SBOX6_INPUT, expected_SBOX7_INPUT, expected_SBOX8_INPUT);
                $display("  Got:      SBOX1_INPUT=%h, SBOX2_INPUT=%h, SBOX3_INPUT=%h, SBOX4_INPUT=%h, SBOX5_INPUT=%h, SBOX6_INPUT=%h, SBOX7_INPUT=%h, SBOX8_INPUT=%h",
                         SBOX1_INPUT, SBOX2_INPUT, SBOX3_INPUT, SBOX4_INPUT, SBOX5_INPUT, SBOX6_INPUT, SBOX7_INPUT, SBOX8_INPUT);
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
