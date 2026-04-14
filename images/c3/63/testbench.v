`timescale 1ns/1ps

module gray_code_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] D;
    wire [3:0] G;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gray_code dut (
        .D(D),
        .G(G)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Input D=0000 (Binary 0)");
        D = 4'b0000;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Input D=0001 (Binary 1)");
        D = 4'b0001;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Input D=0010 (Binary 2)");
        D = 4'b0010;
        #1;

        check_outputs(4'b0011);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Input D=0011 (Binary 3)");
        D = 4'b0011;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Input D=0100 (Binary 4)");
        D = 4'b0100;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Input D=0111 (Binary 7)");
        D = 4'b0111;
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Input D=1000 (Binary 8)");
        D = 4'b1000;
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: Input D=1001 (Binary 9)");
        D = 4'b1001;
        #1;

        check_outputs(4'b1101);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case 009: Input D=1111 (Binary 15)");
        D = 4'b1111;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case 010: Input D=1010 (Binary 10)");
        D = 4'b1010;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gray_code Testbench");
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
