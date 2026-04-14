`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] data;
    wire [5:0] parity;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .parity(parity)
    );
    task testcase001;

    begin
        data = 5'b00000;
        #1;

        check_outputs(6'b000000);
    end
        endtask

    task testcase002;

    begin
        data = 5'b00001;
        #1;

        check_outputs(6'b000011);
    end
        endtask

    task testcase003;

    begin
        data = 5'b00011;
        #1;

        check_outputs(6'b000110);
    end
        endtask

    task testcase004;

    begin
        data = 5'b00111;
        #1;

        check_outputs(6'b001111);
    end
        endtask

    task testcase005;

    begin
        data = 5'b01111;
        #1;

        check_outputs(6'b011110);
    end
        endtask

    task testcase006;

    begin
        data = 5'b11111;
        #1;

        check_outputs(6'b111111);
    end
        endtask

    task testcase007;

    begin
        data = 5'b10101;
        #1;

        check_outputs(6'b101011);
    end
        endtask

    task testcase008;

    begin
        data = 5'b10000;
        #1;

        check_outputs(6'b100001);
    end
        endtask

    task testcase009;

    begin
        data = 5'b11000;
        #1;

        check_outputs(6'b110000);
    end
        endtask

    task testcase010;

    begin
        data = 5'b01010;
        #1;

        check_outputs(6'b010100);
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
        input [5:0] expected_parity;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_parity === (expected_parity ^ parity ^ expected_parity)) begin
                $display("PASS");
                $display("  Outputs: parity=%h",
                         parity);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parity=%h",
                         expected_parity);
                $display("  Got:      parity=%h",
                         parity);
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
