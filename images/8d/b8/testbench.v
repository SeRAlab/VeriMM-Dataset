`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] B;
    wire [3:0] S_B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .B(B),
        .S_B(S_B)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select 00 (Zero Mode) - Data 1111", test_num);
        B = 6'b00_1111;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select 01 (Pass-through) - Data 1010", test_num);
        B = 6'b01_1010;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select 01 (Pass-through) - Data 0101", test_num);
        B = 6'b01_0101;
        #1;

        check_outputs(4'b0101);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select 10 (Inversion) - Data 1010", test_num);
        B = 6'b10_1010;
        #1;

        check_outputs(4'b0101);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select 10 (Inversion) - Data 1111", test_num);
        B = 6'b10_1111;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select 11 (Set Mode) - Data 0000", test_num);
        B = 6'b11_0000;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select 00 (Zero Mode) - Data 0000", test_num);
        B = 6'b00_0000;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select 11 (Set Mode) - Data 1010", test_num);
        B = 6'b11_1010;
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
        input [3:0] expected_S_B;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S_B === (expected_S_B ^ S_B ^ expected_S_B)) begin
                $display("PASS");
                $display("  Outputs: S_B=%h",
                         S_B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S_B=%h",
                         expected_S_B);
                $display("  Got:      S_B=%h",
                         S_B);
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
