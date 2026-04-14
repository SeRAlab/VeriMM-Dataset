`timescale 1ns/1ps

module mux8to1_tb;

    // Testbench signals (combinational circuit)
    reg d0;
    reg d1;
    reg d2;
    reg d3;
    reg d4;
    reg d5;
    reg d6;
    reg d7;
    reg [2:0] sel;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux8to1 dut (
        .d0(d0),
        .d1(d1),
        .d2(d2),
        .d3(d3),
        .d4(d4),
        .d5(d5),
        .d6(d6),
        .d7(d7),
        .sel(sel),
        .y(y)
    );
    task testcase001;

    begin
        test_num = 1;
        sel = 3'b000;
        d0 = 1; d1 = 0; d2 = 0; d3 = 0; d4 = 0; d5 = 0; d6 = 0; d7 = 0;
        $display("Test Case 001: Select d0, d0=1");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        sel = 3'b001;
        d0 = 0; d1 = 1; d2 = 0; d3 = 0; d4 = 0; d5 = 0; d6 = 0; d7 = 0;
        $display("Test Case 002: Select d1, d1=1");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        sel = 3'b010;
        d0 = 1; d1 = 1; d2 = 0; d3 = 1; d4 = 1; d5 = 1; d6 = 1; d7 = 1;
        $display("Test Case 003: Select d2, d2=0 (others=1)");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        sel = 3'b011;
        d0 = 0; d1 = 0; d2 = 0; d3 = 1; d4 = 0; d5 = 0; d6 = 0; d7 = 0;
        $display("Test Case 004: Select d3, d3=1");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        sel = 3'b100;
        d0 = 1; d1 = 1; d2 = 1; d3 = 1; d4 = 0; d5 = 1; d6 = 1; d7 = 1;
        $display("Test Case 005: Select d4, d4=0 (others=1)");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        sel = 3'b101;
        d0 = 0; d1 = 0; d2 = 0; d3 = 0; d4 = 0; d5 = 1; d6 = 0; d7 = 0;
        $display("Test Case 006: Select d5, d5=1");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        sel = 3'b110;
        d0 = 1; d1 = 1; d2 = 1; d3 = 1; d4 = 1; d5 = 1; d6 = 0; d7 = 1;
        $display("Test Case 007: Select d6, d6=0 (others=1)");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        sel = 3'b111;
        d0 = 0; d1 = 0; d2 = 0; d3 = 0; d4 = 0; d5 = 0; d6 = 0; d7 = 1;
        $display("Test Case 008: Select d7, d7=1");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        sel = 3'b111;
        d0 = 1; d1 = 1; d2 = 1; d3 = 1; d4 = 1; d5 = 1; d6 = 1; d7 = 0;
        $display("Test Case 009: Select d7, d7=0 (others=1)");
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
        $display("mux8to1 Testbench");
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
