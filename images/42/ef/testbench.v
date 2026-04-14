`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] consumer_data;
    wire consumer_req;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .consumer_data(consumer_data),
        .consumer_req(consumer_req)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data 0xA, verify req pulse at T=10", test_num);

            consumer_data = 4'h0;
            #1.0;

            consumer_data = 4'hA;

            #8.5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data 0x5, verify req pulse at T=30", test_num);

            consumer_data = 4'h0;
            #1.0;

            consumer_data = 4'h5;

            #18.0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data 0x0, verify req pulse at T=50", test_num);
            consumer_data = 4'hF;
            #1.0;
            consumer_data = 4'h0;

            #18.0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data 0xF, verify req pulse at T=70", test_num);
            consumer_data = 4'h0;
            #1.0;
            consumer_data = 4'hF;

            #18.0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify req is low at T=80 (between pulses)", test_num);
            consumer_data = 4'h0;
            #1.0;

            #8.0;
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
        input expected_consumer_req;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_consumer_req === (expected_consumer_req ^ consumer_req ^ expected_consumer_req)) begin
                $display("PASS");
                $display("  Outputs: consumer_req=%b",
                         consumer_req);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: consumer_req=%b",
                         expected_consumer_req);
                $display("  Got:      consumer_req=%b",
                         consumer_req);
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
