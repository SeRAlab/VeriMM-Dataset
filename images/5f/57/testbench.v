`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a_in;
    reg [31:0] b_in;
    wire [31:0] c_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a_in(a_in),
        .b_in(b_in),
        .c_out(c_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple subtraction (10 - 5)", test_num);
            a_in = 32'd10;
            b_in = 32'd5;
            #1;

            check_outputs(32'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative result (5 - 10)", test_num);
            a_in = 32'd5;
            b_in = 32'd10;
            #1;

            check_outputs(32'hFFFF_FFFB);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero subtraction (0 - 0)", test_num);
            a_in = 32'h0;
            b_in = 32'h0;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max value subtraction (0xFFFFFFFF - 0)", test_num);
            a_in = 32'hFFFF_FFFF;
            b_in = 32'h0;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Result zero (0x12345678 - 0x12345678)", test_num);
            a_in = 32'h1234_5678;
            b_in = 32'h1234_5678;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Wrap around (0 - 1)", test_num);
            a_in = 32'h0;
            b_in = 32'h1;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed boundary (0x80000000 - 1)", test_num);
            a_in = 32'h8000_0000;
            b_in = 32'h0000_0001;
            #1;

            check_outputs(32'h7FFF_FFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large value subtraction", test_num);
            a_in = 32'hAABB_CCDD;
            b_in = 32'h1122_3344;
            #1;

            check_outputs(32'h9999_9999);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max - Max", test_num);
            a_in = 32'hFFFF_FFFF;
            b_in = 32'hFFFF_FFFF;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Result is 1 (0x0 - 0xFFFFFFFF)", test_num);
            a_in = 32'h0000_0000;
            b_in = 32'hFFFF_FFFF;
            #1;

            check_outputs(32'h0000_0001);
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
        input [31:0] expected_c_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c_out === (expected_c_out ^ c_out ^ expected_c_out)) begin
                $display("PASS");
                $display("  Outputs: c_out=%h",
                         c_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c_out=%h",
                         expected_c_out);
                $display("  Got:      c_out=%h",
                         c_out);
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
