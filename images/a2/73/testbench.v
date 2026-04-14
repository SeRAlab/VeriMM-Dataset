`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    wire [15:0] value;
    wire z_s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .value(value),
        .z_s(z_s)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input small positive value", test_num);
            a = 16'h0005;
            #1;

            check_outputs(16'h0005, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input negative one (0xFFFF)", test_num);
            a = 16'hFFFF;

            #1;


            check_outputs(16'h0001, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input zero", test_num);
            a = 16'h0000;
            #1;

            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input max positive signed int (0x7FFF)", test_num);
            a = 16'h7FFF;
            #1;

            check_outputs(16'h7FFF, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input max negative signed int (0x8000)", test_num);
            a = 16'h8000;

            #1;


            check_outputs(16'h8000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input arbitrary negative value (0xABCD)", test_num);
            a = 16'hABCD;

            #1;


            check_outputs(16'h5433, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input arbitrary positive value (0x1234)", test_num);
            a = 16'h1234;
            #1;

            check_outputs(16'h1234, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input negative value 0x8001", test_num);
            a = 16'h8001;

            #1;


            check_outputs(16'h7FFF, 1'b1);
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
        input [15:0] expected_value;
        input expected_z_s;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_value === (expected_value ^ value ^ expected_value) &&
                expected_z_s === (expected_z_s ^ z_s ^ expected_z_s)) begin
                $display("PASS");
                $display("  Outputs: value=%h, z_s=%b",
                         value, z_s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: value=%h, z_s=%b",
                         expected_value, expected_z_s);
                $display("  Got:      value=%h, z_s=%b",
                         value, z_s);
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
