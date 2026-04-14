`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg BTN1;
    reg CLK;
    wire LED1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BTN1(BTN1),
        .CLK(CLK),
        .LED1(LED1)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            BTN1 = 0;

            repeat (5) @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Initial State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Single Press (Toggle ON)", test_num);
            reset_dut();


            BTN1 = 1;
            repeat (2) @(posedge CLK);
            BTN1 = 0;
            repeat (2) @(posedge CLK);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Double Press (Toggle ON -> OFF)", test_num);
            reset_dut();


            BTN1 = 1;
            repeat (2) @(posedge CLK);
            BTN1 = 0;
            repeat (2) @(posedge CLK);


            BTN1 = 1;
            repeat (2) @(posedge CLK);
            BTN1 = 0;
            repeat (2) @(posedge CLK);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Long Press (Edge Detect)", test_num);
            reset_dut();


            BTN1 = 1;
            repeat (10) @(posedge CLK);


            #1;



            check_outputs(1'b1);

            BTN1 = 0;
            repeat (2) @(posedge CLK);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Rapid Triple Press", test_num);
            reset_dut();


            repeat (3) begin
                BTN1 = 1;
                @(posedge CLK);
                BTN1 = 0;
                @(posedge CLK);
            end


            #1;



            check_outputs(1'b1);
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
        input expected_LED1;
        begin
            if (expected_LED1 === (expected_LED1 ^ LED1 ^ expected_LED1)) begin
                $display("PASS");
                $display("  Outputs: LED1=%b",
                         LED1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LED1=%b",
                         expected_LED1);
                $display("  Got:      LED1=%b",
                         LED1);
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
        $dumpvars(0,BTN1, CLK, LED1);
    end

endmodule
