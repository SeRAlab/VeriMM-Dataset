`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] RmIn;
    reg [4:0] RtIn;
    reg Select;
    wire [4:0] rrA2Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RmIn(RmIn),
        .RtIn(RtIn),
        .Select(Select),
        .rrA2Out(rrA2Out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select RmIn with specific values", test_num);
        RmIn = 5'h0A;
        RtIn = 5'h15;
        Select = 1'b0;
        #1;

        check_outputs(5'h0A);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select RtIn with specific values", test_num);
        RmIn = 5'h0A;
        RtIn = 5'h15;
        Select = 1'b1;
        #1;

        check_outputs(5'h15);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero inputs, Select RmIn", test_num);
        RmIn = 5'b00000;
        RtIn = 5'b11111;
        Select = 1'b0;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max inputs, Select RtIn", test_num);
        RmIn = 5'b00000;
        RtIn = 5'b11111;
        Select = 1'b1;
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating bits, Select RmIn", test_num);
        RmIn = 5'b10101;
        RtIn = 5'b01010;
        Select = 1'b0;
        #1;

        check_outputs(5'b10101);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating bits, Select RtIn", test_num);
        RmIn = 5'b10101;
        RtIn = 5'b01010;
        Select = 1'b1;
        #1;

        check_outputs(5'b01010);
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
        input [4:0] expected_rrA2Out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rrA2Out === (expected_rrA2Out ^ rrA2Out ^ expected_rrA2Out)) begin
                $display("PASS");
                $display("  Outputs: rrA2Out=%h",
                         rrA2Out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rrA2Out=%h",
                         expected_rrA2Out);
                $display("  Got:      rrA2Out=%h",
                         rrA2Out);
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
