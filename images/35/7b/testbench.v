`timescale 1ns/1ps

module max_heap_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    reg [3:0] d;
    wire [3:0] max_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    max_heap dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .max_out(max_out)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 4'd10; b = 4'd5; c = 4'd2; d = 4'd8;
        $display("Test %0d: Max is at 'a' (10)", test_num);
        #1;

        check_outputs(4'd10);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 4'd1; b = 4'd15; c = 4'd3; d = 4'd12;
        $display("Test %0d: Max is at 'b' (15)", test_num);
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 4'd4; b = 4'd6; c = 4'd13; d = 4'd1;
        $display("Test %0d: Max is at 'c' (13)", test_num);
        #1;

        check_outputs(4'd13);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 4'd0; b = 4'd7; c = 4'd5; d = 4'd14;
        $display("Test %0d: Max is at 'd' (14)", test_num);
        #1;

        check_outputs(4'd14);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 4'd9; b = 4'd9; c = 4'd9; d = 4'd9;
        $display("Test %0d: All inputs are equal (9)", test_num);
        #1;

        check_outputs(4'd9);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 4'd0; b = 4'd0; c = 4'd0; d = 4'd0;
        $display("Test %0d: All inputs are zero", test_num);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 4'd15; b = 4'd0; c = 4'd15; d = 4'd2;
        $display("Test %0d: Two inputs are max (15)", test_num);
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 4'd11; b = 4'd11; c = 4'd11; d = 4'd3;
        $display("Test %0d: Three inputs are max (11)", test_num);
        #1;

        check_outputs(4'd11);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 4'd2; b = 4'd4; c = 4'd8; d = 4'd6;
        $display("Test %0d: Max is 8", test_num);
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 4'd1; b = 4'd2; c = 4'd3; d = 4'd4;
        $display("Test %0d: Ascending order, max is 4", test_num);
        #1;

        check_outputs(4'd4);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("max_heap Testbench");
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
        input [3:0] expected_max_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_max_out === (expected_max_out ^ max_out ^ expected_max_out)) begin
                $display("PASS");
                $display("  Outputs: max_out=%h",
                         max_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: max_out=%h",
                         expected_max_out);
                $display("  Got:      max_out=%h",
                         max_out);
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
