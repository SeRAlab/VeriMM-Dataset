`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] din0;
    reg [4:0] din1;
    reg [4:0] din2;
    reg [1:0] op;
    wire [4:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din0(din0),
        .din1(din1),
        .din2(din2),
        .op(op),
        .dout(dout)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Select din0 (op=00)");
        din0 = 5'h0A; din1 = 5'h15; din2 = 5'h1F;
        op = 2'b00;
        #1;

        check_outputs(5'h0A);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Select din1 (op=01)");
        din0 = 5'h0A; din1 = 5'h15; din2 = 5'h1F;
        op = 2'b01;
        #1;

        check_outputs(5'h15);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Select din2 (op=10)");
        din0 = 5'h0A; din1 = 5'h15; din2 = 5'h1F;
        op = 2'b10;
        #1;

        check_outputs(5'h1F);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: All zeros, op=00");
        din0 = 5'h00; din1 = 5'h00; din2 = 5'h00;
        op = 2'b00;
        #1;

        check_outputs(5'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: All ones, op=01");
        din0 = 5'h1F; din1 = 5'h1F; din2 = 5'h1F;
        op = 2'b01;
        #1;

        check_outputs(5'h1F);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Alternating bits, op=10");
        din0 = 5'h00; din1 = 5'h00; din2 = 5'h12;
        op = 2'b10;
        #1;

        check_outputs(5'h12);
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
        input [4:0] expected_dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
