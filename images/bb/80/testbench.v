`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ce;
    reg [7:0] data;
    reg rw;
    wire [7:0] leds;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ce(ce),
        .data(data),
        .rw(rw),
        .leds(leds)
    );
    task testcase001;

    begin
        test_num = 1;

        ce = 0; rw = 0; data = 8'h00;
        #10;

        data = 8'hFF; rw = 0;
        #10;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        ce = 0; rw = 0; data = 8'h00; #10;
        ce = 1; rw = 0; data = 8'hAA; #10;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        ce = 0; rw = 0; data = 8'h00; #10;
        ce = 1; rw = 0; data = 8'h55; #10;
        ce = 1; rw = 1; data = 8'hFF; #10;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        ce = 0; rw = 0; data = 8'h00; #10;
        ce = 1; rw = 0; data = 8'hF0; #10;
        ce = 0; rw = 0; data = 8'hF0; #10;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        ce = 0; rw = 0; data = 8'h00; #10;
        ce = 1; rw = 0; data = 8'h33; #10;
        #1;

        check_outputs(8'h33);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        ce = 0; rw = 0; data = 8'h00; #10;
        ce = 1; rw = 0; data = 8'hCC; #10;
        ce = 0; rw = 1; data = 8'hCC; #10;
        #1;

        check_outputs(8'h00);
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
        input [7:0] expected_leds;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_leds === (expected_leds ^ leds ^ expected_leds)) begin
                $display("PASS");
                $display("  Outputs: leds=%h",
                         leds);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: leds=%h",
                         expected_leds);
                $display("  Got:      leds=%h",
                         leds);
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
