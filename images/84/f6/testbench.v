`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] addr;
    reg cs_;
    wire cs0;
    wire cs1;
    wire cs2;
    wire cs3;
    wire cs4;
    wire cs5;
    wire cs6;
    wire cs7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .cs_(cs_),
        .cs0(cs0),
        .cs1(cs1),
        .cs2(cs2),
        .cs3(cs3),
        .cs4(cs4),
        .cs5(cs5),
        .cs6(cs6),
        .cs7(cs7)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Chip select disabled, addr=0", test_num);
            cs_ = 1;
            addr = 32'h0000_0000;
            #1;

            check_outputs(1, 1, 1, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select cs0 (prefix 0)", test_num);
            cs_ = 0;
            addr = 32'h0000_0000;
            #1;

            check_outputs(0, 1, 1, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select cs1 (prefix 2)", test_num);
            cs_ = 0;
            addr = (10'h002 << 22);
            #1;

            check_outputs(1, 0, 1, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select cs2 (prefix 4)", test_num);
            cs_ = 0;
            addr = (10'h004 << 22);
            #1;

            check_outputs(1, 1, 0, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Select cs3 (prefix 6)", test_num);
            cs_ = 0;
            addr = (10'h006 << 22);
            #1;

            check_outputs(1, 1, 1, 0, 1, 1, 1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Select cs4 (prefix 8)", test_num);
            cs_ = 0;
            addr = (10'h008 << 22);
            #1;

            check_outputs(1, 1, 1, 1, 0, 1, 1, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Select cs5 (prefix A)", test_num);
            cs_ = 0;
            addr = (10'h00A << 22);
            #1;

            check_outputs(1, 1, 1, 1, 1, 0, 1, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Select cs6 (prefix C)", test_num);
            cs_ = 0;
            addr = (10'h00C << 22);
            #1;

            check_outputs(1, 1, 1, 1, 1, 1, 0, 1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Select cs7 (prefix E)", test_num);
            cs_ = 0;
            addr = (10'h00E << 22);
            #1;

            check_outputs(1, 1, 1, 1, 1, 1, 1, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Unmapped address prefix (prefix 1)", test_num);
            cs_ = 0;
            addr = (10'h001 << 22);
            #1;

            check_outputs(1, 1, 1, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Testcase %0d: Valid prefix 2, but chip select disabled", test_num);
            cs_ = 1;
            addr = (10'h002 << 22);
            #1;

            check_outputs(1, 1, 1, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Testcase %0d: Valid prefix 2 with non-zero offset bits", test_num);
            cs_ = 0;
            addr = (10'h002 << 22) | 32'h003F_FFFF;
            #1;

            check_outputs(1, 0, 1, 1, 1, 1, 1, 1);
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
        testcase012();
        
        
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
        input expected_cs0;
        input expected_cs1;
        input expected_cs2;
        input expected_cs3;
        input expected_cs4;
        input expected_cs5;
        input expected_cs6;
        input expected_cs7;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cs0 === (expected_cs0 ^ cs0 ^ expected_cs0) &&
                expected_cs1 === (expected_cs1 ^ cs1 ^ expected_cs1) &&
                expected_cs2 === (expected_cs2 ^ cs2 ^ expected_cs2) &&
                expected_cs3 === (expected_cs3 ^ cs3 ^ expected_cs3) &&
                expected_cs4 === (expected_cs4 ^ cs4 ^ expected_cs4) &&
                expected_cs5 === (expected_cs5 ^ cs5 ^ expected_cs5) &&
                expected_cs6 === (expected_cs6 ^ cs6 ^ expected_cs6) &&
                expected_cs7 === (expected_cs7 ^ cs7 ^ expected_cs7)) begin
                $display("PASS");
                $display("  Outputs: cs0=%b, cs1=%b, cs2=%b, cs3=%b, cs4=%b, cs5=%b, cs6=%b, cs7=%b",
                         cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cs0=%b, cs1=%b, cs2=%b, cs3=%b, cs4=%b, cs5=%b, cs6=%b, cs7=%b",
                         expected_cs0, expected_cs1, expected_cs2, expected_cs3, expected_cs4, expected_cs5, expected_cs6, expected_cs7);
                $display("  Got:      cs0=%b, cs1=%b, cs2=%b, cs3=%b, cs4=%b, cs5=%b, cs6=%b, cs7=%b",
                         cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7);
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
