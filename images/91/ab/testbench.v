`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] g;
    reg [15:0] p;
    wire [3:0] bg;
    wire [3:0] bp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .g(g),
        .p(p),
        .bg(bg),
        .bp(bp)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            g = 16'h0000;
            p = 16'h0000;
            #1;

            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All ones in G", test_num);
            g = 16'hffff;
            p = 16'h0000;
            #1;

            check_outputs(4'hf, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All ones in P", test_num);
            g = 16'h0000;
            p = 16'hffff;
            #1;

            check_outputs(4'h0, 4'hf);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Propagation Chain", test_num);
            g = 16'h0001;
            p = 16'h000f;
            #1;

            check_outputs(4'h1, 4'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Interleaved P and G", test_num);
            p = 16'haaaa;
            g = 16'h5555;
            #1;

            check_outputs(4'hf, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Nibble level distribution", test_num);
            p = 16'hf0f0;
            g = 16'h0f0f;
            #1;

            check_outputs(4'h5, 4'ha);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Deep chain generate", test_num);
            p = 16'heeee;
            g = 16'h1111;
            #1;

            check_outputs(4'hf, 4'h0);
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
        input [3:0] expected_bg;
        input [3:0] expected_bp;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bg === (expected_bg ^ bg ^ expected_bg) &&
                expected_bp === (expected_bp ^ bp ^ expected_bp)) begin
                $display("PASS");
                $display("  Outputs: bg=%h, bp=%h",
                         bg, bp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bg=%h, bp=%h",
                         expected_bg, expected_bp);
                $display("  Got:      bg=%h, bp=%h",
                         bg, bp);
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
