`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] d;
    reg [1:0] s;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d(d),
        .s(s),
        .y(y)
    );
    task testcase001;

    begin
        d = 4'b0000;
        s = 2'b00;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        d = 4'b1101;
        s = 2'b00;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        d = 4'b1101;
        s = 2'b01;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        d = 4'b0010;
        s = 2'b01;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        d = 4'b1101;
        s = 2'b10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        d = 4'b0010;
        s = 2'b10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        d = 4'b0101;
        s = 2'b11;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        d = 4'b1010;
        s = 2'b11;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        d = 4'b1100;
        s = 2'b00;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        d = 4'b1110;
        s = 2'b01;
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
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%b",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%b",
                         expected_y);
                $display("  Got:      y=%b",
                         y);
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
