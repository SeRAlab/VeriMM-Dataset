`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] a_e;
    reg [27:0] z;
    wire [15:0] output_z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a_e(a_e),
        .z(z),
        .output_z(output_z)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            a_e = 6'b101111; z = 28'hFFFFFFF;
            #10;
            $display("Testcase %0d: Condition 1 (a_e=47) - Output should be 0", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            a_e = 6'b010000; z = 28'h0000000;
            #10;
            $display("Testcase %0d: Condition 2 (a_e=16) - Output should be FFFF", test_num);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            a_e = 6'b011111; z = 28'h1234567;
            #10;
            $display("Testcase %0d: Condition 2 (a_e=31) - Output should be FFFF", test_num);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            a_e = 6'b001111; z = 28'hA5A5A5A;
            #10;
            $display("Testcase %0d: Condition 3 (a_e=15) - Output should be z[27:12]", test_num);
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            a_e = 6'b110000; z = 28'h5A5B5C5;
            #10;
            $display("Testcase %0d: Condition 3 (a_e=48) - Output should be z[27:12]", test_num);
            #1;

            check_outputs(16'h5A5B);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            a_e = 6'b100000; z = 28'h1234BC0;
            #10;
            $display("Testcase %0d: Condition 3 (a_e=32) - Output should be z[27:12]", test_num);
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            a_e = 6'b000000; z = 28'hDEADBEE;
            #10;
            $display("Testcase %0d: Condition 3 (a_e=0) - Output should be z[27:12]", test_num);
            #1;

            check_outputs(16'hDEAD);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            a_e = 6'b111111; z = 28'h0123456;
            #10;
            $display("Testcase %0d: Condition 3 (Shift Check) - Output should be 0123", test_num);
            #1;

            check_outputs(16'h0123);
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
        input [15:0] expected_output_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_z === (expected_output_z ^ output_z ^ expected_output_z)) begin
                $display("PASS");
                $display("  Outputs: output_z=%h",
                         output_z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_z=%h",
                         expected_output_z);
                $display("  Got:      output_z=%h",
                         output_z);
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
