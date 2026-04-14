`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] din0;
    reg [31:0] din1;
    reg [31:0] din2;
    reg [31:0] din3;
    reg [1:0] select;
    wire [31:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din0(din0),
        .din1(din1),
        .din2(din2),
        .din3(din3),
        .select(select),
        .dout(dout)
    );
    task testcase001;

        begin
            $display("Testcase 001: Selecting din0 with pattern 0xAAAAAAAA");
            din0 = 32'hAAAAAAAA;
            din1 = 32'h55555555;
            din2 = 32'h00000000;
            din3 = 32'hFFFFFFFF;
            select = 2'b00;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Selecting din1 with pattern 0x55555555");
            din0 = 32'hAAAAAAAA;
            din1 = 32'h55555555;
            din2 = 32'h00000000;
            din3 = 32'hFFFFFFFF;
            select = 2'b01;
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Selecting din2 with pattern 0x00000000");
            din0 = 32'hAAAAAAAA;
            din1 = 32'h55555555;
            din2 = 32'h00000000;
            din3 = 32'hFFFFFFFF;
            select = 2'b10;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Selecting din3 with pattern 0xFFFFFFFF");
            din0 = 32'hAAAAAAAA;
            din1 = 32'h55555555;
            din2 = 32'h00000000;
            din3 = 32'hFFFFFFFF;
            select = 2'b11;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Verifying data integrity for din0 (0x12345678)");
            din0 = 32'h12345678;
            din1 = 32'h9ABCDEF0;
            din2 = 32'h0FEDCBA9;
            din3 = 32'h87654321;
            select = 2'b00;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Verifying data integrity for din1 (0x9ABCDEF0)");
            din0 = 32'h12345678;
            din1 = 32'h9ABCDEF0;
            din2 = 32'h0FEDCBA9;
            din3 = 32'h87654321;
            select = 2'b01;
            #1;

            check_outputs(32'h9ABCDEF0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Verifying data integrity for din2 (0x0FEDCBA9)");
            din0 = 32'h12345678;
            din1 = 32'h9ABCDEF0;
            din2 = 32'h0FEDCBA9;
            din3 = 32'h87654321;
            select = 2'b10;
            #1;

            check_outputs(32'h0FEDCBA9);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Verifying data integrity for din3 (0x87654321)");
            din0 = 32'h12345678;
            din1 = 32'h9ABCDEF0;
            din2 = 32'h0FEDCBA9;
            din3 = 32'h87654321;
            select = 2'b11;
            #1;

            check_outputs(32'h87654321);
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
        input [31:0] expected_dout;
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
