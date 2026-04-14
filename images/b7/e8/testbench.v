`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] D;
    reg [5:0] S;
    wire M256;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .S(S),
        .M256(M256)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select bit 0 (Expected: 1)", test_num);
            D = 64'h0000_0000_0000_0001;
            S = 6'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select bit 0 (Expected: 0)", test_num);
            D = 64'hFFFF_FFFF_FFFF_FFFE;
            S = 6'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select bit 63 (Expected: 1)", test_num);
            D = 64'h8000_0000_0000_0000;
            S = 6'd63;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select bit 63 (Expected: 0)", test_num);
            D = 64'h7FFF_FFFF_FFFF_FFFF;
            S = 6'd63;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Select bit 31 (Boundary mid-low, Expected: 1)", test_num);
            D = 64'h0000_0000_8000_0000;
            S = 6'd31;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Select bit 32 (Boundary mid-high, Expected: 1)", test_num);
            D = 64'h0000_0001_0000_0000;
            S = 6'd32;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Random selection bit 10 (Expected: 1)", test_num);
            D = (64'h1 << 10);
            S = 6'd10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Random selection bit 45 (Expected: 0)", test_num);
            D = ~(64'h1 << 45);
            S = 6'd45;
            #1;

            check_outputs(1'b0);
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
        input expected_M256;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_M256 === (expected_M256 ^ M256 ^ expected_M256)) begin
                $display("PASS");
                $display("  Outputs: M256=%b",
                         M256);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: M256=%b",
                         expected_M256);
                $display("  Got:      M256=%b",
                         M256);
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
