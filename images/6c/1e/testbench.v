`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [14:0] c;
    wire [10:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c(c),
        .q(q)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros - No Error", test_num);
        c = 15'b000_0000_0000_0000;
        #1;

        check_outputs(11'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros - Error in Bit 1 (Parity)", test_num);
        c = 15'b000_0000_0000_0001;
        #1;

        check_outputs(11'h000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros - Error in Bit 15 (Data)", test_num);
        c = 15'b100_0000_0000_0000;
        #1;

        check_outputs(11'h000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Ones - No Error", test_num);
        c = 15'b111_1111_1111_1111;
        #1;

        check_outputs(11'h7FF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Ones - Error in Bit 8 (Parity)", test_num);
        c = 15'b111_1111_0111_1111;
        #1;

        check_outputs(11'h7FF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pattern 0x555 - No Error", test_num);
        c = 15'b101_0101_0010_1101;
        #1;

        check_outputs(11'h555);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pattern 0x555 - Error in Bit 3 (Data)", test_num);
        c = 15'b101_0101_0010_1001;
        #1;

        check_outputs(11'h555);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pattern 0x333 - No Error", test_num);
        c = 15'b011_0011_0001_1110;
        #1;

        check_outputs(11'h333);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pattern 0x333 - Error in Bit 13 (Data)", test_num);
        c = 15'b010_0011_0001_1110;
        #1;

        check_outputs(11'h333);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pattern 0x333 - Error in Bit 2 (Parity)", test_num);
        c = 15'b011_0011_0001_1100;
        #1;

        check_outputs(11'h333);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pattern 0x333 - Error in Bit 4 (Parity)", test_num);
        c = 15'b011_0011_0000_1110;
        #1;

        check_outputs(11'h333);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pattern 0x333 - Error in Bit 15 (Data)", test_num);
        c = 15'b111_0011_0001_1110;
        #1;

        check_outputs(11'h333);
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
        input [10:0] expected_q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
