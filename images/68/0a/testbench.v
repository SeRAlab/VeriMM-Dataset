`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [16:0] irqOffset;
    reg [5:0] irqVector;
    wire [7:0] irqNumber;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .irqOffset(irqOffset),
        .irqVector(irqVector),
        .irqNumber(irqNumber)
    );
    task testcase001;

        reg [7:0] expected;
        begin
            test_num = test_num + 1;
            irqVector = 6'b000000;
            irqOffset = 17'h00000;

            `ifdef EIC_USE_EXPLICIT_VECTOR_OFFSET
                expected = 8'h00;
            `else
                expected = 8'h00;
            `endif

            $display("Testcase %03d: All zeros", test_num);
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase002;

        reg [7:0] expected;
        begin
            test_num = test_num + 1;
            irqVector = 6'b111111;
            irqOffset = 17'h00000;

            `ifdef EIC_USE_EXPLICIT_VECTOR_OFFSET
                expected = 8'h00;
            `else
                expected = 8'h3F;
            `endif

            $display("Testcase %03d: Max IRQ Vector (0x3F)", test_num);
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase003;

        reg [7:0] expected;
        begin
            test_num = test_num + 1;
            irqVector = 6'b000000;
            irqOffset = 17'h00010;

            `ifdef EIC_USE_EXPLICIT_VECTOR_OFFSET
                expected = 8'h01;
            `else
                expected = 8'h00;
            `endif

            $display("Testcase %03d: Offset 0x10 (Expected IRQ 1 in Explicit mode)", test_num);
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase004;

        reg [7:0] expected;
        begin
            test_num = test_num + 1;
            irqVector = 6'h2A;
            irqOffset = 17'h00A50;

            `ifdef EIC_USE_EXPLICIT_VECTOR_OFFSET
                expected = 8'hA5;
            `else
                expected = 8'h2A;
            `endif

            $display("Testcase %03d: Offset 0xA50 vs Vector 0x2A", test_num);
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase005;

        reg [7:0] expected;
        begin
            test_num = test_num + 1;
            irqVector = 6'h05;
            irqOffset = 17'h0001F;

            `ifdef EIC_USE_EXPLICIT_VECTOR_OFFSET
                expected = 8'h01;
            `else
                expected = 8'h05;
            `endif

            $display("Testcase %03d: Offset 0x1F (Shift granularity check)", test_num);
            #1;

            check_outputs(expected);
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
        input [7:0] expected_irqNumber;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_irqNumber === (expected_irqNumber ^ irqNumber ^ expected_irqNumber)) begin
                $display("PASS");
                $display("  Outputs: irqNumber=%h",
                         irqNumber);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: irqNumber=%h",
                         expected_irqNumber);
                $display("  Got:      irqNumber=%h",
                         irqNumber);
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
