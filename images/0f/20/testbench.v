`timescale 1ns/1ps

module fir_filter_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] x;
    reg [2:0] x1;
    reg [2:0] x2;
    wire [2:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fir_filter dut (
        .x(x),
        .x1(x1),
        .x2(x2),
        .y(y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: All zeros", test_num);
        x = 3'd0; x1 = 3'd0; x2 = 3'd0;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Small values no overflow", test_num);
        x = 3'd1; x1 = 3'd1; x2 = 3'd1;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Max single input", test_num);
        x = 3'd7; x1 = 3'd0; x2 = 3'd0;
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Sum exactly 8 (overflow to 0)", test_num);
        x = 3'd4; x1 = 3'd2; x2 = 3'd2;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Full overflow (7+7+7)", test_num);
        x = 3'd7; x1 = 3'd7; x2 = 3'd7;
        #1;

        check_outputs(3'd5);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Step sequence", test_num);
        x = 3'd3; x1 = 3'd2; x2 = 3'd1;
        #1;

        check_outputs(3'd6);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Sum to 15 (overflow to 7)", test_num);
        x = 3'd5; x1 = 3'd5; x2 = 3'd5;
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Sum to 4", test_num);
        x = 3'd1; x1 = 3'd2; x2 = 3'd1;
        #1;

        check_outputs(3'd4);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Sum to 12 (overflow to 4)", test_num);
        x = 3'd4; x1 = 3'd4; x2 = 3'd4;
        #1;

        check_outputs(3'd4);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Mixed zeros and max", test_num);
        x = 3'd7; x1 = 3'd0; x2 = 3'd1;
        #1;

        check_outputs(3'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fir_filter Testbench");
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
        input [2:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
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
