`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] YAxis;
    reg clock;
    reg [15:0] meteor;
    reg [15:0] move;
    wire METEOR_F;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .YAxis(YAxis),
        .clock(clock),
        .meteor(meteor),
        .move(move),
        .METEOR_F(METEOR_F)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Zeroes", test_num);
        YAxis = 16'h0000;
        meteor = 16'h0000;
        move = 16'h0000;

        clock = 0; #5; clock = 1; #5; clock = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Match on Bit 0", test_num);
        YAxis = 16'h0001;
        move = 16'h0000;
        meteor = 16'h0001;
        clock = 0; #5; clock = 1; #5; clock = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Movement Offset Match", test_num);
        YAxis = 16'h0001;
        move = 16'h0001;
        meteor = 16'h0002;
        clock = 0; #5; clock = 1; #5; clock = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: No Overlap", test_num);
        YAxis = 16'h0002;
        move = 16'h0001;
        meteor = 16'h0004;
        clock = 0; #5; clock = 1; #5; clock = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: High Bit Overlap", test_num);
        YAxis = 16'h8000;
        move = 16'h0000;
        meteor = 16'hF000;
        clock = 0; #5; clock = 1; #5; clock = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Overflow Case", test_num);
        YAxis = 16'hFFFF;
        move = 16'h0001;
        meteor = 16'hFFFF;
        clock = 0; #5; clock = 1; #5; clock = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multi-bit Overlap", test_num);
        YAxis = 16'h00AA;
        move = 16'h0000;
        meteor = 16'h00FF;
        clock = 0; #5; clock = 1; #5; clock = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Complex Sum No Match", test_num);
        YAxis = 16'd100;
        move = 16'd155;
        meteor = 16'h0100;
        clock = 0; #5; clock = 1; #5; clock = 0;
        #1;

        check_outputs(1'b0);
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
        input expected_METEOR_F;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_METEOR_F === (expected_METEOR_F ^ METEOR_F ^ expected_METEOR_F)) begin
                $display("PASS");
                $display("  Outputs: METEOR_F=%b",
                         METEOR_F);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: METEOR_F=%b",
                         expected_METEOR_F);
                $display("  Got:      METEOR_F=%b",
                         METEOR_F);
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
