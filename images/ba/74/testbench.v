`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] comp_val;
    reg [63:0] in;
    reg [3:0] sel;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .comp_val(comp_val),
        .in(in),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select segment 0, match expected", test_num);
            in = 64'h0000_0000_0000_000A;
            sel = 4'h0;
            comp_val = 4'hA;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select segment 0, no match", test_num);
            in = 64'h0000_0000_0000_000A;
            sel = 4'h0;
            comp_val = 4'h5;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select last segment (15), match expected", test_num);
            in = 64'hF000_0000_0000_0000;
            sel = 4'hF;
            comp_val = 4'hF;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select last segment (15), no match", test_num);
            in = 64'hE000_0000_0000_0000;
            sel = 4'hF;
            comp_val = 4'hF;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Middle segment (7) match", test_num);

            in = 64'h0000_0000_B000_0000;
            sel = 4'h7;
            comp_val = 4'hB;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Multiple segments match comp_val, select non-matching", test_num);

            in = 64'h5555_5555_5555_5C55;
            sel = 4'h4;
            comp_val = 4'h5;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Boundary check - match all zeros", test_num);
            in = 64'hFFFF_FFFF_0FFF_FFFF;
            sel = 4'h7;
            comp_val = 4'h0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Boundary check - match all ones", test_num);
            in = 64'h0000_0000_F000_0000;
            sel = 4'h7;
            comp_val = 4'hF;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Verification of adjacent segments (Index 1 vs 2)", test_num);
            in = 64'h0000_0000_0000_0210;
            sel = 4'h1;
            comp_val = 4'h1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Verification of adjacent segments (Wrong selector)", test_num);
            in = 64'h0000_0000_0000_0210;
            sel = 4'h2;
            comp_val = 4'h1;
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
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
