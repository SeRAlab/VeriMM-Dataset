`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    reg input_signal;
    wire delayed_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .input_signal(input_signal),
        .delayed_signal(delayed_signal)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Power up and verify low input propagation", test_num);

            VGND = 1'b0;
            VNB  = 1'b0;
            VPB  = 1'b1;
            VPWR = 1'b1;
            input_signal = 1'b0;


            #100;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Verify logic high propagation", test_num);

            input_signal = 1'b0;
            #20;


            input_signal = 1'b1;


            #100;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Verify logic low propagation after high state", test_num);

            input_signal = 1'b1;
            #20;


            input_signal = 1'b0;


            #100;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Verify stability after multiple transitions", test_num);

            input_signal = 1'b0;
            #20;


            input_signal = 1'b1; #50;
            input_signal = 1'b0; #50;
            input_signal = 1'b1; #100;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Final logic level check with stable power", test_num);

            VGND = 1'b0;
            VPWR = 1'b1;

            input_signal = 1'b0;
            #100;

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
        input expected_delayed_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_delayed_signal === (expected_delayed_signal ^ delayed_signal ^ expected_delayed_signal)) begin
                $display("PASS");
                $display("  Outputs: delayed_signal=%b",
                         delayed_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: delayed_signal=%b",
                         expected_delayed_signal);
                $display("  Got:      delayed_signal=%b",
                         delayed_signal);
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
