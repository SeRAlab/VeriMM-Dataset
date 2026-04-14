`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] add_in1;
    reg [31:0] add_in2;
    wire [31:0] add_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .add_in1(add_in1),
        .add_in2(add_in2),
        .add_out(add_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero inputs", test_num);
            add_in1 = 32'h00000000;
            add_in2 = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small positive integers", test_num);
            add_in1 = 32'd15;
            add_in2 = 32'd27;
            #1;

            check_outputs(32'd42);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large values without carry out", test_num);
            add_in1 = 32'h10000000;
            add_in2 = 32'h20000000;
            #1;

            check_outputs(32'h30000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum value wrap-around (Carry bit ignored)", test_num);
            add_in1 = 32'hFFFFFFFF;
            add_in2 = 32'h00000001;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bit patterns", test_num);
            add_in1 = 32'hAAAAAAAA;
            add_in2 = 32'h55555555;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry propagation through all bits", test_num);
            add_in1 = 32'hFFFFFFFF;
            add_in2 = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random hexadecimal values", test_num);
            add_in1 = 32'h12345678;
            add_in2 = 32'h87654321;
            #1;

            check_outputs(32'h99999999);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB addition", test_num);
            add_in1 = 32'h80000000;
            add_in2 = 32'h80000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bitwise carry triggers", test_num);
            add_in1 = 32'h0F0F0F0F;
            add_in2 = 32'hF0F0F0F0;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sub-word addition check", test_num);
            add_in1 = 32'h0000FFFF;
            add_in2 = 32'h00000001;
            #1;

            check_outputs(32'h00010000);
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
        input [31:0] expected_add_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_add_out === (expected_add_out ^ add_out ^ expected_add_out)) begin
                $display("PASS");
                $display("  Outputs: add_out=%h",
                         add_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: add_out=%h",
                         expected_add_out);
                $display("  Got:      add_out=%h",
                         add_out);
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
