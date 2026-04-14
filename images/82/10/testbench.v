`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg PSWI;
    reg [15:0] externalInterrupts;
    reg [15:0] internalInterrupts;
    wire [31:0] address;
    wire [3:0] interruptNumber;
    wire interruptPresent;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PSWI(PSWI),
        .externalInterrupts(externalInterrupts),
        .internalInterrupts(internalInterrupts),
        .address(address),
        .interruptNumber(interruptNumber),
        .interruptPresent(interruptPresent)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: All inputs zero", test_num);
        externalInterrupts = 16'h0000;
        internalInterrupts = 16'h0000;
        PSWI = 0;
        #1;

        check_outputs(32'h0, 4'h0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: External active, PSWI low (No interrupt should trigger)", test_num);
        externalInterrupts = 16'h0010;
        internalInterrupts = 16'h0000;
        PSWI = 0;
        #1;

        check_outputs(32'h0, 4'h0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: External active, PSWI high (Interrupt 4 expected)", test_num);
        externalInterrupts = 16'h0010;
        internalInterrupts = 16'h0000;
        PSWI = 1;
        #1;

        check_outputs(32'd4, 4'd4, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Internal active (Interrupt 8 expected)", test_num);
        externalInterrupts = 16'h0000;
        internalInterrupts = 16'h0100;
        PSWI = 0;
        #1;

        check_outputs(32'd8, 4'd8, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Multiple external bits, PSWI high (Interrupt 15 expected)", test_num);
        externalInterrupts = 16'h8011;
        internalInterrupts = 16'h0000;
        PSWI = 1;
        #1;

        check_outputs(32'd15, 4'd15, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Multiple internal bits (Interrupt 12 expected)", test_num);
        externalInterrupts = 16'h0000;
        internalInterrupts = 16'h10F0;
        PSWI = 1;
        #1;

        check_outputs(32'd12, 4'd12, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: External bit 14 vs Internal bit 2, PSWI high (Interrupt 14 expected)", test_num);
        externalInterrupts = 16'h4000;
        internalInterrupts = 16'h0004;
        PSWI = 1;
        #1;

        check_outputs(32'd14, 4'd14, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Internal bit 10 vs External bit 5, PSWI high (Interrupt 10 expected)", test_num);
        externalInterrupts = 16'h0020;
        internalInterrupts = 16'h0400;
        PSWI = 1;
        #1;

        check_outputs(32'd10, 4'd10, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: External bit 15 (PSWI=0) vs Internal bit 1 (Interrupt 1 expected)", test_num);
        externalInterrupts = 16'h8000;
        internalInterrupts = 16'h0002;
        PSWI = 0;
        #1;

        check_outputs(32'd1, 4'd1, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Lowest bit check (Interrupt 0 expected)", test_num);
        externalInterrupts = 16'h0000;
        internalInterrupts = 16'h0001;
        PSWI = 0;
        #1;

        check_outputs(32'd0, 4'd0, 1'b1);
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
        input [31:0] expected_address;
        input [3:0] expected_interruptNumber;
        input expected_interruptPresent;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_address === (expected_address ^ address ^ expected_address) &&
                expected_interruptNumber === (expected_interruptNumber ^ interruptNumber ^ expected_interruptNumber) &&
                expected_interruptPresent === (expected_interruptPresent ^ interruptPresent ^ expected_interruptPresent)) begin
                $display("PASS");
                $display("  Outputs: address=%h, interruptNumber=%h, interruptPresent=%b",
                         address, interruptNumber, interruptPresent);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: address=%h, interruptNumber=%h, interruptPresent=%b",
                         expected_address, expected_interruptNumber, expected_interruptPresent);
                $display("  Got:      address=%h, interruptNumber=%h, interruptPresent=%b",
                         address, interruptNumber, interruptPresent);
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
