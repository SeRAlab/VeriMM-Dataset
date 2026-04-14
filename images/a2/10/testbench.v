`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg address;
    reg clock;
    reg reset_n;
    wire [31:0] readdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clock(clock),
        .reset_n(reset_n),
        .readdata(readdata)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Read Address 0 (Expect -252645136)", test_num);

            reset_n = 0;
            address = 0;
            @(posedge clock);
            #1;
            reset_n = 1;

            address = 0;
            @(posedge clock);

            #1;


            check_outputs(-252645136);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Read Address 1 (Expect 1413429550)", test_num);

            reset_n = 0;
            address = 0;
            @(posedge clock);
            #1;
            reset_n = 1;

            address = 1;
            @(posedge clock);

            #1;


            check_outputs(1413429550);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transition Address 0 to 1", test_num);

            reset_n = 0;
            address = 0;
            @(posedge clock);
            #1;
            reset_n = 1;

            address = 0;
            @(posedge clock);
            address = 1;
            @(posedge clock);

            #1;


            check_outputs(1413429550);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transition Address 1 to 0", test_num);

            reset_n = 0;
            address = 1;
            @(posedge clock);
            #1;
            reset_n = 1;

            address = 1;
            @(posedge clock);
            address = 0;
            @(posedge clock);

            #1;


            check_outputs(-252645136);
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
        input [31:0] expected_readdata;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_readdata === (expected_readdata ^ readdata ^ expected_readdata)) begin
                $display("PASS");
                $display("  Outputs: readdata=%h",
                         readdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: readdata=%h",
                         expected_readdata);
                $display("  Got:      readdata=%h",
                         readdata);
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
