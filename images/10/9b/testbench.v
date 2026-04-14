`timescale 1ns/1ps

module max_heap_comparator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    wire [3:0] max_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    max_heap_comparator dut (
        .a(a),
        .b(b),
        .c(c),
        .max_out(max_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: a is max", test_num);
        a = 4'd12; b = 4'd5; c = 4'd8;
        #1;

        check_outputs(4'd12);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: b is max", test_num);
        a = 4'd2; b = 4'd15; c = 4'd10;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: c is max", test_num);
        a = 4'd7; b = 4'd3; c = 4'd14;
        #1;

        check_outputs(4'd14);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: All equal", test_num);
        a = 4'd9; b = 4'd9; c = 4'd9;
        #1;

        check_outputs(4'd9);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %0d: a and b are equal max", test_num);
        a = 4'd11; b = 4'd11; c = 4'd4;
        #1;

        check_outputs(4'd11);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest Case %0d: b and c are equal max", test_num);
        a = 4'd1; b = 4'd13; c = 4'd13;
        #1;

        check_outputs(4'd13);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTest Case %0d: Two equal, one larger", test_num);
        a = 4'd2; b = 4'd2; c = 4'd5;
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTest Case %0d: All zeros", test_num);
        a = 4'd0; b = 4'd0; c = 4'd0;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("\nTest Case %0d: Max 4-bit values (15)", test_num);
        a = 4'd15; b = 4'd0; c = 4'd15;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("\nTest Case %0d: Low values", test_num);
        a = 4'd1; b = 4'd2; c = 4'd3;
        #1;

        check_outputs(4'd3);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("max_heap_comparator Testbench");
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
