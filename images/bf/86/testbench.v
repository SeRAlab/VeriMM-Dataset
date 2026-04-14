`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] C;
    wire [6:0] Display;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .C(C),
        .Display(Display)
    );
    task testcase001;

    begin
        test_num = 1;
        C = 3'b000;
        $display("Test Case 001: Input C=000 (Expect 'H')");
        #1;

        check_outputs(7'b1110110);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        C = 3'b001;
        $display("Test Case 002: Input C=001 (Expect 'E')");
        #1;

        check_outputs(7'b1111001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        C = 3'b010;
        $display("Test Case 003: Input C=010 (Expect 'L')");
        #1;

        check_outputs(7'b0111000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        C = 3'b011;
        $display("Test Case 004: Input C=011 (Expect 'O')");
        #1;

        check_outputs(7'b0111111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        C = 3'b100;
        $display("Test Case 005: Input C=100 (Expect Blank)");
        #1;

        check_outputs(7'b0000000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        C = 3'b101;
        $display("Test Case 006: Input C=101 (Expect Blank)");
        #1;

        check_outputs(7'b0000000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        C = 3'b110;
        $display("Test Case 007: Input C=110 (Expect Blank)");
        #1;

        check_outputs(7'b0000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        C = 3'b111;
        $display("Test Case 008: Input C=111 (Expect Blank)");
        #1;

        check_outputs(7'b0000000);
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
        input [6:0] expected_Display;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Display === (expected_Display ^ Display ^ expected_Display)) begin
                $display("PASS");
                $display("  Outputs: Display=%h",
                         Display);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Display=%h",
                         expected_Display);
                $display("  Got:      Display=%h",
                         Display);
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
