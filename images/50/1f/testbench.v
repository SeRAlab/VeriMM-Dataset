`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg PIN_14;
    wire LED;
    wire USBPU;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .PIN_14(PIN_14),
        .LED(LED),
        .USBPU(USBPU)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin


            PIN_14 = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: PIN_14 Low", test_num);
            reset_dut();


            PIN_14 = 0;


            #100;




            #1;





            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: PIN_14 High (Initial Active State)", test_num);
            reset_dut();


            PIN_14 = 1;




            #100;





            #1;






            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Input Transition Check", test_num);
            reset_dut();


            PIN_14 = 1;
            #50;
            PIN_14 = 0;
            #50;
            PIN_14 = 1;
            #100;


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: USBPU Constant Low Verification", test_num);
            reset_dut();


            PIN_14 = 1;
            #1000;


            #1;



            check_outputs(1'b1, 1'b0);
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
        input expected_LED;
        input expected_USBPU;
        begin
            if (expected_LED === (expected_LED ^ LED ^ expected_LED) &&
                expected_USBPU === (expected_USBPU ^ USBPU ^ expected_USBPU)) begin
                $display("PASS");
                $display("  Outputs: LED=%b, USBPU=%b",
                         LED, USBPU);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LED=%b, USBPU=%b",
                         expected_LED, expected_USBPU);
                $display("  Got:      LED=%b, USBPU=%b",
                         LED, USBPU);
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
        $dumpvars(0,CLK, PIN_14, LED, USBPU);
    end

endmodule
