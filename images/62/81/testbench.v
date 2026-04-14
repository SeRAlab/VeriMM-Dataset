`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ce;
    reg clk;
    reg clr;
    reg [33:0] input_port;
    wire [33:0] output_port;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ce(ce),
        .clk(clk),
        .clr(clr),
        .input_port(input_port),
        .output_port(output_port)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Input", test_num);

            clk = 0; ce = 1; clr = 1; #10;
            clr = 0; #10;

            input_port = 34'sd0;
            #10;
            #1;

            check_outputs(34'h000000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Small Positive Value", test_num);

            clk = 0; ce = 1; clr = 1; #10;
            clr = 0; #10;

            input_port = 34'sd12345;
            #10;
            #1;

            check_outputs(34'h000003039);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative Value (-1)", test_num);

            clk = 0; ce = 1; clr = 1; #10;
            clr = 0; #10;

            input_port = -34'sd1;
            #10;
            #1;

            check_outputs(34'h3FFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max Signed Positive Value", test_num);

            clk = 0; ce = 1; clr = 1; #10;
            clr = 0; #10;

            input_port = 34'sh1FFFFFFFF;
            #10;
            #1;

            check_outputs(34'h1FFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Min Signed Negative Value", test_num);

            clk = 0; ce = 1; clr = 1; #10;
            clr = 0; #10;

            input_port = 34'sh200000000;
            #10;
            #1;

            check_outputs(34'h200000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Arbitrary Negative Pattern", test_num);

            clk = 0; ce = 1; clr = 1; #10;
            clr = 0; #10;

            input_port = -34'sd1048576;
            #10;
            #1;

            check_outputs(34'h3FF000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits", test_num);

            clk = 0; ce = 1; clr = 1; #10;
            clr = 0; #10;

            input_port = 34'h2AAAAAAAA;
            #10;
            #1;

            check_outputs(34'h2AAAAAAAA);
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
        input [33:0] expected_output_port;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_port === (expected_output_port ^ output_port ^ expected_output_port)) begin
                $display("PASS");
                $display("  Outputs: output_port=%h",
                         output_port);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_port=%h",
                         expected_output_port);
                $display("  Got:      output_port=%h",
                         output_port);
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
