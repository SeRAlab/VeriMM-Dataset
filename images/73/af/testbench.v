`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] encoded;
    wire [4:0] decoded;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .encoded(encoded),
        .decoded(decoded)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: No bits set (Default Case)", test_num);
            encoded = 24'h000000;
            #1;

            check_outputs(5'd23);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Bit 0 set (Highest Priority)", test_num);
            encoded = 24'h000001;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Bit 1 set", test_num);
            encoded = 24'h000002;
            #1;

            check_outputs(5'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Bits 0 and 1 set (Check priority of Bit 0)", test_num);
            encoded = 24'h000003;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Bit 23 set (Lowest Priority index)", test_num);
            encoded = 24'h800000;
            #1;

            check_outputs(5'd23);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Bit 22 set", test_num);
            encoded = 24'h400000;
            #1;

            check_outputs(5'd22);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Bits 22 and 23 set (Check priority of Bit 22)", test_num);
            encoded = 24'hC00000;
            #1;

            check_outputs(5'd22);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Multiple bits set (10, 11, 12)", test_num);
            encoded = 24'h001C00;
            #1;

            check_outputs(5'd10);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: All bits set (Priority should be Bit 0)", test_num);
            encoded = 24'hFFFFFF;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Alternating bits (0xAAAAAA - starts at bit 1)", test_num);
            encoded = 24'hAAAAAA;
            #1;

            check_outputs(5'd1);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Testcase %0d: High bit and Low bit (Bit 0 and Bit 23)", test_num);
            encoded = 24'h800001;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Testcase %0d: Sparse bit (Bit 15)", test_num);
            encoded = 24'h008000;
            #1;

            check_outputs(5'd15);
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
        input [4:0] expected_decoded;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_decoded === (expected_decoded ^ decoded ^ expected_decoded)) begin
                $display("PASS");
                $display("  Outputs: decoded=%h",
                         decoded);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decoded=%h",
                         expected_decoded);
                $display("  Got:      decoded=%h",
                         decoded);
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
