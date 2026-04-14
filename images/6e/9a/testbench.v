`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK_IN;
    reg [7:0] PWM_DCycle;
    wire PWM_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK_IN(CLK_IN),
        .PWM_DCycle(PWM_DCycle),
        .PWM_OUT(PWM_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK_IN = 0;
        forever #5 CLK_IN = ~CLK_IN;
    end

        task reset_dut;

        begin
            PWM_DCycle = 8'd0;



            if ((global_cycles % 256) != 0) begin
                repeat(256 - (global_cycles % 256)) @(posedge CLK_IN);
            end else begin
                repeat(256) @(posedge CLK_IN);
            end

            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Duty Cycle 0 (Min) - Expecting Low in mid-cycle", test_num);
            reset_dut();
            PWM_DCycle = 8'd0;
            repeat(100) @(posedge CLK_IN);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Duty Cycle 255 (Max) - Expecting High", test_num);
            reset_dut();
            PWM_DCycle = 8'd255;
            repeat(100) @(posedge CLK_IN);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Duty Cycle 127 - Expecting High at start of period", test_num);
            reset_dut();
            PWM_DCycle = 8'd127;
            repeat(50) @(posedge CLK_IN);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Duty Cycle 127 - Expecting Low at end of period", test_num);
            reset_dut();
            PWM_DCycle = 8'd127;
            repeat(200) @(posedge CLK_IN);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Duty Cycle 30 - Expecting Low after transition", test_num);
            reset_dut();
            PWM_DCycle = 8'd30;
            repeat(50) @(posedge CLK_IN);
            #1 #1;
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
        input expected_PWM_OUT;
        begin
            if (expected_PWM_OUT === (expected_PWM_OUT ^ PWM_OUT ^ expected_PWM_OUT)) begin
                $display("PASS");
                $display("  Outputs: PWM_OUT=%b",
                         PWM_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PWM_OUT=%b",
                         expected_PWM_OUT);
                $display("  Got:      PWM_OUT=%b",
                         PWM_OUT);
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
        $dumpvars(0,CLK_IN, PWM_DCycle, PWM_OUT);
    end

endmodule
