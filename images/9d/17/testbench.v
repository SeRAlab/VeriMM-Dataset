`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] step_i;
    wire [31:0] K_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .step_i(step_i),
        .K_o(K_o)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SHA-256 Constant K[0]", test_num);
            step_i = 6'd0;
            #1;

            check_outputs(32'h428a2f98);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SHA-256 Constant K[7]", test_num);
            step_i = 6'd7;
            #1;

            check_outputs(32'hab1c5ed5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SHA-256 Constant K[15]", test_num);
            step_i = 6'd15;
            #1;

            check_outputs(32'hc19bf174);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SHA-256 Constant K[31]", test_num);
            step_i = 6'd31;
            #1;

            check_outputs(32'h14292967);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SHA-256 Constant K[47]", test_num);
            step_i = 6'd47;
            #1;

            check_outputs(32'h106aa070);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SHA-256 Constant K[63]", test_num);
            step_i = 6'd63;
            #1;

            check_outputs(32'hc67178f2);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SHA-256 Constant K[24]", test_num);
            step_i = 6'd24;
            #1;

            check_outputs(32'h983e5152);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SHA-256 Constant K[52]", test_num);
            step_i = 6'd52;
            #1;

            check_outputs(32'h391c0cb3);
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
        input [31:0] expected_K_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_K_o === (expected_K_o ^ K_o ^ expected_K_o)) begin
                $display("PASS");
                $display("  Outputs: K_o=%h",
                         K_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: K_o=%h",
                         expected_K_o);
                $display("  Got:      K_o=%h",
                         K_o);
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
