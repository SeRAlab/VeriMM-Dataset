`timescale 1ns/1ps

module binary_to_gray_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] binary_in;
    wire [11:0] gray_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_to_gray dut (
        .binary_in(binary_in),
        .gray_out(gray_out)
    );
    task testcase001;

        begin
            test_num = 1;
            binary_in = 12'h000;
            $display("\nTestcase %0d: Input 12'h000", test_num);
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            binary_in = 12'h001;
            $display("\nTestcase %0d: Input 12'h001", test_num);
            #1;

            check_outputs(12'h001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            binary_in = 12'h002;
            $display("\nTestcase %0d: Input 12'h002", test_num);
            #1;

            check_outputs(12'h003);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            binary_in = 12'h003;
            $display("\nTestcase %0d: Input 12'h003", test_num);
            #1;

            check_outputs(12'h002);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            binary_in = 12'h800;
            $display("\nTestcase %0d: Input 12'h800", test_num);
            #1;

            check_outputs(12'hC00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            binary_in = 12'hAAA;
            $display("\nTestcase %0d: Input 12'hAAA", test_num);
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            binary_in = 12'h555;
            $display("\nTestcase %0d: Input 12'h555", test_num);
            #1;

            check_outputs(12'h7FF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            binary_in = 12'hFFF;
            $display("\nTestcase %0d: Input 12'hFFF", test_num);
            #1;

            check_outputs(12'h800);
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
        input [11:0] expected_gray_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_gray_out === (expected_gray_out ^ gray_out ^ expected_gray_out)) begin
                $display("PASS");
                $display("  Outputs: gray_out=%h",
                         gray_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gray_out=%h",
                         expected_gray_out);
                $display("  Got:      gray_out=%h",
                         gray_out);
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
