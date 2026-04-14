`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg devclrn;
    reg devpor;
    reg ena;
    reg inclk;
    wire enaout;
    wire outclk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .devclrn(devclrn),
        .devpor(devpor),
        .ena(ena),
        .inclk(inclk),
        .enaout(enaout),
        .outclk(outclk)
    );

    // Clock generation (10ns period)
    initial begin
        inclk = 0;
        forever #5 inclk = ~inclk;
    end

        task reset_dut;

        begin
            devpor = 0;
            devclrn = 0;
            ena = 0;
            #20;
            devpor = 1;
            devclrn = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            devpor = 0;
            devclrn = 1;
            ena = 1;
            #12;
            $display("Test %0d: Power-on reset active (devpor=0)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            devpor = 1;
            devclrn = 0;
            ena = 1;
            #12;
            $display("Test %0d: Device clear active (devclrn=0)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            devpor = 1;
            devclrn = 1;
            ena = 0;
            #12;
            $display("Test %0d: Resets inactive, enable low", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            devpor = 1;
            devclrn = 1;
            ena = 1;

            @(posedge inclk);
            #2;
            $display("Test %0d: Enabled, inclk high phase", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            devpor = 1;
            devclrn = 1;
            ena = 1;

            @(negedge inclk);
            #2;
            $display("Test %0d: Enabled, inclk low phase", test_num);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            devpor = 1;
            devclrn = 1;
            ena = 1;
            #20;
            ena = 0;
            #20;
            $display("Test %0d: Dynamic disable during operation", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_enaout;
        input expected_outclk;
        begin
            if (expected_enaout === (expected_enaout ^ enaout ^ expected_enaout) &&
                expected_outclk === (expected_outclk ^ outclk ^ expected_outclk)) begin
                $display("PASS");
                $display("  Outputs: enaout=%b, outclk=%b",
                         enaout, outclk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: enaout=%b, outclk=%b",
                         expected_enaout, expected_outclk);
                $display("  Got:      enaout=%b, outclk=%b",
                         enaout, outclk);
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
        $dumpvars(0,devclrn, devpor, ena, inclk, enaout, outclk);
    end

endmodule
