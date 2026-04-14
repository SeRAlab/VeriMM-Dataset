`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] bits;
    wire client_req;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bits(bits),
        .client_req(client_req)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: All bits set to 0", test_num);
        bits = 2'b00;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Only bit 0 set to 1", test_num);
        bits = 2'b01;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Only bit 1 set to 1", test_num);
        bits = 2'b10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: All bits set to 1 (Request Expected)", test_num);
        bits = 2'b11;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Transition from all 1s back to partial 0", test_num);
        bits = 2'b11;
        #1;
        bits = 2'b10;
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
        input expected_client_req;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_client_req === (expected_client_req ^ client_req ^ expected_client_req)) begin
                $display("PASS");
                $display("  Outputs: client_req=%b",
                         client_req);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: client_req=%b",
                         expected_client_req);
                $display("  Got:      client_req=%b",
                         client_req);
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
