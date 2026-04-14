`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [33:0] HADDR;
    wire HSELx0;
    wire HSELx1;
    wire HSELx2;
    wire HSELx3;
    wire HSELx4;
    wire HSELx5;
    wire HSELx6;
    wire HSELx7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .HADDR(HADDR),
        .HSELx0(HSELx0),
        .HSELx1(HSELx1),
        .HSELx2(HSELx2),
        .HSELx3(HSELx3),
        .HSELx4(HSELx4),
        .HSELx5(HSELx5),
        .HSELx6(HSELx6),
        .HSELx7(HSELx7)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: Testing HSELx0 (Address Prefix 3'b000)", test_num);
        HADDR = 34'b000_0000000000000000000000000000000;
        #1;

        check_outputs(1, 0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: Testing HSELx1 (Address Prefix 3'b001)", test_num);
        HADDR = 34'b001_0000000000000000000000000000000;
        #1;

        check_outputs(0, 1, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: Testing HSELx2 (Address Prefix 3'b010)", test_num);
        HADDR = 34'b010_0000000000000000000000000000000;
        #1;

        check_outputs(0, 0, 1, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: Testing HSELx3 (Address Prefix 3'b011)", test_num);
        HADDR = 34'b011_0000000000000000000000000000000;
        #1;

        check_outputs(0, 0, 0, 1, 0, 0, 0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %0d: Testing HSELx4 (Address Prefix 3'b100)", test_num);
        HADDR = 34'b100_0000000000000000000000000000000;
        #1;

        check_outputs(0, 0, 0, 0, 1, 0, 0, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest Case %0d: Testing HSELx5 (Address Prefix 3'b101)", test_num);
        HADDR = 34'b101_0000000000000000000000000000000;
        #1;

        check_outputs(0, 0, 0, 0, 0, 1, 0, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTest Case %0d: Testing HSELx6 (Address Prefix 3'b110)", test_num);
        HADDR = 34'b110_0000000000000000000000000000000;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0, 1, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTest Case %0d: Testing HSELx7 (Address Prefix 3'b111)", test_num);
        HADDR = 34'b111_1111111111111111111111111111111;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0, 0, 1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("\nTest Case %0d: Boundary check for Device 2 (0x4_0000_0000)", test_num);
        HADDR = 34'h4_FFFF_FFFF;
        #1;

        check_outputs(0, 0, 1, 0, 0, 0, 0, 0);
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
        input expected_HSELx0;
        input expected_HSELx1;
        input expected_HSELx2;
        input expected_HSELx3;
        input expected_HSELx4;
        input expected_HSELx5;
        input expected_HSELx6;
        input expected_HSELx7;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_HSELx0 === (expected_HSELx0 ^ HSELx0 ^ expected_HSELx0) &&
                expected_HSELx1 === (expected_HSELx1 ^ HSELx1 ^ expected_HSELx1) &&
                expected_HSELx2 === (expected_HSELx2 ^ HSELx2 ^ expected_HSELx2) &&
                expected_HSELx3 === (expected_HSELx3 ^ HSELx3 ^ expected_HSELx3) &&
                expected_HSELx4 === (expected_HSELx4 ^ HSELx4 ^ expected_HSELx4) &&
                expected_HSELx5 === (expected_HSELx5 ^ HSELx5 ^ expected_HSELx5) &&
                expected_HSELx6 === (expected_HSELx6 ^ HSELx6 ^ expected_HSELx6) &&
                expected_HSELx7 === (expected_HSELx7 ^ HSELx7 ^ expected_HSELx7)) begin
                $display("PASS");
                $display("  Outputs: HSELx0=%b, HSELx1=%b, HSELx2=%b, HSELx3=%b, HSELx4=%b, HSELx5=%b, HSELx6=%b, HSELx7=%b",
                         HSELx0, HSELx1, HSELx2, HSELx3, HSELx4, HSELx5, HSELx6, HSELx7);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: HSELx0=%b, HSELx1=%b, HSELx2=%b, HSELx3=%b, HSELx4=%b, HSELx5=%b, HSELx6=%b, HSELx7=%b",
                         expected_HSELx0, expected_HSELx1, expected_HSELx2, expected_HSELx3, expected_HSELx4, expected_HSELx5, expected_HSELx6, expected_HSELx7);
                $display("  Got:      HSELx0=%b, HSELx1=%b, HSELx2=%b, HSELx3=%b, HSELx4=%b, HSELx5=%b, HSELx6=%b, HSELx7=%b",
                         HSELx0, HSELx1, HSELx2, HSELx3, HSELx4, HSELx5, HSELx6, HSELx7);
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
