`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg VDD;
    wire RST;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .VDD(VDD),
        .RST(RST)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Power-off state (VDD=0)", test_num);

        VDD = 0;
        #100;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: VDD High, checking before 1s delay (0.5s mark)", test_num);

        VDD = 0;
        #100;
        VDD = 1;

        #500000000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: VDD High, checking after 1s delay (1.1s mark)", test_num);

        VDD = 0;
        #100;
        VDD = 1;

        #1100000000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: VDD drops after being stable", test_num);

        VDD = 0;
        #100;
        VDD = 1;
        #1100000000;
        VDD = 0;
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
        input expected_RST;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_RST === (expected_RST ^ RST ^ expected_RST)) begin
                $display("PASS");
                $display("  Outputs: RST=%b",
                         RST);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RST=%b",
                         expected_RST);
                $display("  Got:      RST=%b",
                         RST);
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
