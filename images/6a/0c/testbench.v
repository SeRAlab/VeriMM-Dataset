`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            a = 32'h00000002;
            $display("Test %0d: Positive number shift", test_num);
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            a = 32'h80000000;
            $display("Test %0d: Minimum negative value (MSB=1)", test_num);
            #1;

            check_outputs(32'hC0000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            a = 32'h00000000;
            $display("Test %0d: All zeros", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            a = 32'hFFFFFFFF;
            $display("Test %0d: All ones", test_num);
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            a = 32'hAAAAAAAA;
            $display("Test %0d: Alternating bits (MSB=1)", test_num);
            #1;

            check_outputs(32'hD5555555);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            a = 32'h55555555;
            $display("Test %0d: Alternating bits (MSB=0)", test_num);
            #1;

            check_outputs(32'h2AAAAAAA);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            a = 32'h12345678;
            $display("Test %0d: General positive pattern", test_num);
            #1;

            check_outputs(32'h091A2B3C);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            a = 32'h80000001;
            $display("Test %0d: MSB and LSB set", test_num);
            #1;

            check_outputs(32'hC0000000);
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
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
