`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] state;
    wire [5:0] state_debug;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .state(state),
        .state_debug(state_debug)
    );
    task testcase001;

    begin
        test_num = 1;
        state = 6'b000000;
        $display("Test %0d: All zeros", test_num);
        #1;

        check_outputs(6'b000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        state = 6'b111111;
        $display("Test %0d: All ones", test_num);
        #1;

        check_outputs(6'b111111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        state = 6'b101010;
        $display("Test %0d: Alternating pattern 1", test_num);
        #1;

        check_outputs(6'b101010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        state = 6'b010101;
        $display("Test %0d: Alternating pattern 2", test_num);
        #1;

        check_outputs(6'b010101);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        state = 6'b110011;
        $display("Test %0d: Mixed pattern 1", test_num);
        #1;

        check_outputs(6'b110011);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        state = 6'b001100;
        $display("Test %0d: Mixed pattern 2", test_num);
        #1;

        check_outputs(6'b001100);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        state = 6'b100001;
        $display("Test %0d: Boundary bits set", test_num);
        #1;

        check_outputs(6'b100001);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        state = 6'h1F;
        $display("Test %0d: Lower 5 bits set", test_num);
        #1;

        check_outputs(6'h1F);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        state = 6'h20;
        $display("Test %0d: Only MSB set", test_num);
        #1;

        check_outputs(6'h20);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        state = 6'h01;
        $display("Test %0d: Only LSB set", test_num);
        #1;

        check_outputs(6'h01);
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
        input [5:0] expected_state_debug;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_state_debug === (expected_state_debug ^ state_debug ^ expected_state_debug)) begin
                $display("PASS");
                $display("  Outputs: state_debug=%h",
                         state_debug);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state_debug=%h",
                         expected_state_debug);
                $display("  Got:      state_debug=%h",
                         state_debug);
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
