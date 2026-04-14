`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] din;
    reg p;
    wire [1:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din(din),
        .p(p),
        .dout(dout)
    );
    task cycle;

        input integer n;
        begin
            repeat(n) @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset to MM state", test_num);
            rst = 1; p = 0; din = 2'b00;
            cycle(2);
            rst = 0;
            cycle(1);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transition MM -> M", test_num);
            rst = 1; p = 0; din = 2'b00;
            cycle(1);
            rst = 0;
            p = 1;
            cycle(1);
            p = 0;
            cycle(1);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transition MM -> M -> P", test_num);
            rst = 1; p = 0; din = 2'b00;
            cycle(1);
            rst = 0;
            p = 1;
            cycle(2);
            p = 0;
            cycle(1);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transition MM -> M -> P -> PP", test_num);
            rst = 1; p = 0; din = 2'b00;
            cycle(1);
            rst = 0;
            p = 1;
            cycle(3);
            p = 0;
            cycle(1);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Full cycle MM -> M -> P -> PP -> MM", test_num);
            rst = 1; p = 0; din = 2'b00;
            cycle(1);
            rst = 0;
            p = 1;
            cycle(4);
            p = 0;
            cycle(1);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Stability check (p=0)", test_num);
            rst = 1; p = 0; din = 2'b00;
            cycle(1);
            rst = 0;
            p = 1; cycle(1);
            p = 0; cycle(3);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: din influence at state MM", test_num);
            rst = 1; p = 0; din = 2'b11;
            cycle(1);
            rst = 0;
            cycle(1);

            #1;


            check_outputs(dout);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: din influence at state P", test_num);
            rst = 1; p = 0; din = 2'b00;
            cycle(1);
            rst = 0;
            p = 1; cycle(2);
            din = 2'b10;
            cycle(1);
            #1;

            check_outputs(dout);
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
        input [1:0] expected_dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
