`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] inp;
    reg [4:0] sel;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inp(inp),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select input 0 (Logic High)", test_num);
            inp = 32'h00000001;
            sel = 5'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select input 31 (Logic High)", test_num);
            inp = 32'h80000000;
            sel = 5'd31;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select input 15 (Logic Low in High Field)", test_num);
            inp = 32'hFFFF7FFF;
            sel = 5'd15;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Testcase group: Walking One Test");
            for (i = 0; i < 32; i = i + 1) begin
                test_num = test_num + 1;
                inp = (1 << i);
                sel = i[4:0];
                #1;

                check_outputs(1'b1);
            end
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Testcase group: Walking Zero Test");
            for (i = 0; i < 32; i = i + 1) begin
                test_num = test_num + 1;
                inp = ~(1 << i);
                sel = i[4:0];
                #1;

                check_outputs(1'b0);
            end
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Checkerboard Pattern (Odd Index)", test_num);
            inp = 32'hAAAAAAAA;
            sel = 5'd1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Checkerboard Pattern (Even Index)", test_num);
            inp = 32'hAAAAAAAA;
            sel = 5'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random Pattern Test", test_num);
            inp = 32'h12345678;


            sel = 5'd3;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random Pattern Test 2", test_num);
            inp = 32'h12345678;

            sel = 5'd2;
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
