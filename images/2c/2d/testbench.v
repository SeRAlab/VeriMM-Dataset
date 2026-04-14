`timescale 1ns/1ps

module wallace_tree_adder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    wire [8:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wallace_tree_adder dut (
        .a(a),
        .b(b),
        .c(c),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: All inputs zero", test_num);
        a = 8'd0; b = 8'd0; c = 8'd0;
        #1;

        check_outputs(9'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Minimum non-zero values", test_num);
        a = 8'd1; b = 8'd1; c = 8'd1;
        #1;

        check_outputs(9'd3);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Single input non-zero (a)", test_num);
        a = 8'd255; b = 8'd0; c = 8'd0;
        #1;

        check_outputs(9'd255);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Single input non-zero (b)", test_num);
        a = 8'd0; b = 8'd255; c = 8'd0;
        #1;

        check_outputs(9'd255);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Single input non-zero (c)", test_num);
        a = 8'd0; b = 8'd0; c = 8'd255;
        #1;

        check_outputs(9'd255);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Mid-range values", test_num);
        a = 8'd100; b = 8'd100; c = 8'd100;
        #1;

        check_outputs(9'd300);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Power of 2 boundaries", test_num);
        a = 8'd128; b = 8'd64; c = 8'd32;
        #1;

        check_outputs(9'd224);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Maximum 9-bit sum result", test_num);
        a = 8'd255; b = 8'd255; c = 8'd1;
        #1;

        check_outputs(9'd511);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Max inputs (Truncated sum check)", test_num);
        a = 8'd255; b = 8'd255; c = 8'd255;
        #1;

        check_outputs(9'd765 & 9'h1FF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Alternating bit patterns", test_num);
        a = 8'hAA; b = 8'h55; c = 8'h00;
        #1;

        check_outputs(9'd255);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wallace_tree_adder Testbench");
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
        input [8:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
