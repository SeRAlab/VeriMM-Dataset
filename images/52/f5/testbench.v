`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [5:0] delayctrlin;
    reg [3:0] phasectrlin;
    wire delayed_clkout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .delayctrlin(delayctrlin),
        .phasectrlin(phasectrlin),
        .delayed_clkout(delayed_clkout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            delayctrlin = 6'b0;
            phasectrlin = 4'b0;
            #20;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum Delay (Gray=0, Phase=0)", test_num);
            delayctrlin = 6'b000000;
            phasectrlin = 4'b0000;
            #82;
            #1;

            check_outputs(expected_val(6'b000000, 4'b0000, 102));
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Gray 1, Phase 0", test_num);
            delayctrlin = 6'b000001;
            phasectrlin = 4'b0000;
            #82;
            #1;

            check_outputs(expected_val(6'b000001, 4'b0000, 102));
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Gray 3 (Bin 2), Phase 0", test_num);
            delayctrlin = 6'b000011;
            phasectrlin = 4'b0000;
            #82;
            #1;

            check_outputs(expected_val(6'b000011, 4'b0000, 102));
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Gray 0, Phase 1", test_num);
            delayctrlin = 6'b000000;
            phasectrlin = 4'b0001;
            #82;
            #1;

            check_outputs(expected_val(6'b000000, 4'b0001, 102));
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Gray 000110 (Bin 4), Phase 2", test_num);
            delayctrlin = 6'b000110;
            phasectrlin = 4'b0010;
            #82;
            #1;

            check_outputs(expected_val(6'b000110, 4'b0010, 102));
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: High Gray Value (6'b110000)", test_num);
            delayctrlin = 6'b110000;
            phasectrlin = 4'b0000;
            #82;
            #1;

            check_outputs(expected_val(6'b110000, 4'b0000, 102));
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Phase Max (15)", test_num);
            delayctrlin = 6'b000000;
            phasectrlin = 4'b1111;
            #102;
            #1;

            check_outputs(expected_val(6'b000000, 4'b1111, 122));
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Max Constraints", test_num);
            delayctrlin = 6'b100000;
            phasectrlin = 4'b1111;
            #152;
            #1;

            check_outputs(expected_val(6'b100000, 4'b1111, 172));
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
        input expected_delayed_clkout;
        begin
            if (expected_delayed_clkout === (expected_delayed_clkout ^ delayed_clkout ^ expected_delayed_clkout)) begin
                $display("PASS");
                $display("  Outputs: delayed_clkout=%b",
                         delayed_clkout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: delayed_clkout=%b",
                         expected_delayed_clkout);
                $display("  Got:      delayed_clkout=%b",
                         delayed_clkout);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, delayctrlin, phasectrlin, delayed_clkout);
    end

endmodule
