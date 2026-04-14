`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] addrb;
    reg enb;
    wire [2:0] enb_array;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addrb(addrb),
        .enb(enb),
        .enb_array(enb_array)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: enb=0, addrb=2'b00", test_num);
            enb = 1'b0;
            addrb = 2'b00;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: enb=0, addrb=2'b10", test_num);
            enb = 1'b0;
            addrb = 2'b10;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: enb=1, addrb=2'b00", test_num);
            enb = 1'b1;
            addrb = 2'b00;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: enb=1, addrb=2'b01", test_num);
            enb = 1'b1;
            addrb = 2'b01;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: enb=1, addrb=2'b10", test_num);
            enb = 1'b1;
            addrb = 2'b10;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: enb=1, addrb=2'b11 (Out of Range)", test_num);
            enb = 1'b1;
            addrb = 2'b11;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Toggle enb 1 -> 0", test_num);
            enb = 1'b1;
            addrb = 2'b01;
            #5;
            enb = 1'b0;
            #1;

            check_outputs(3'b000);
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
        input [2:0] expected_enb_array;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_enb_array === (expected_enb_array ^ enb_array ^ expected_enb_array)) begin
                $display("PASS");
                $display("  Outputs: enb_array=%h",
                         enb_array);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: enb_array=%h",
                         expected_enb_array);
                $display("  Got:      enb_array=%h",
                         enb_array);
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
