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

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing Minimum Values", test_num);
            irqVector = 6'b000000;
            irqOffset = 17'h00000;
            #10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing Maximum Vector", test_num);
            irqVector = 6'b111111;
            irqOffset = 17'h00000;
            #10;
            #1;

            check_outputs(8'h3F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing Alternating Bit Pattern (0x2A)", test_num);
            irqVector = 6'b101010;
            irqOffset = 17'h15555;
            #10;
            #1;

            check_outputs(8'h2A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing Alternating Bit Pattern (0x15)", test_num);
            irqVector = 6'b010101;
            irqOffset = 17'h0AAAA;
            #10;
            #1;

            check_outputs(8'h15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing Maximum Offset Influence", test_num);
            irqVector = 6'b001100;
            irqOffset = 17'h1FFFF;
            #10;
            #1;

            check_outputs(8'h0C);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing Specific Vector 0x10", test_num);
            irqVector = 6'h10;
            irqOffset = 17'h01234;
            #10;
            #1;

            check_outputs(8'h10);
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
