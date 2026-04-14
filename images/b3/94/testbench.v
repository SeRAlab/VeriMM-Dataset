`timescale 1ns/1ps

module comparator2bit_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] a;
    reg [1:0] b;
    reg clk;
    wire a_eq_b;
    wire a_gt_b;
    wire a_lt_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    comparator2bit dut (
        .a(a),
        .b(b),
        .clk(clk),
        .a_eq_b(a_eq_b),
        .a_gt_b(a_gt_b),
        .a_lt_b(a_lt_b)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a <= 2'b00;
            b <= 2'b00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: a=00, b=00 (Equal)", test_num);
            a <= 2'b00;
            b <= 2'b00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: a=01, b=00 (Greater)", test_num);
            a <= 2'b01;
            b <= 2'b00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: a=00, b=10 (Less)", test_num);
            a <= 2'b00;
            b <= 2'b10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: a=11, b=11 (Equal)", test_num);
            a <= 2'b11;
            b <= 2'b11;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: a=11, b=01 (Greater)", test_num);
            a <= 2'b11;
            b <= 2'b01;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: a=01, b=10 (Less)", test_num);
            a <= 2'b01;
            b <= 2'b10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: a=10, b=01 (Greater)", test_num);
            a <= 2'b10;
            b <= 2'b01;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: a=01, b=11 (Less)", test_num);
            a <= 2'b01;
            b <= 2'b11;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: a=10, b=10 (Equal)", test_num);
            a <= 2'b10;
            b <= 2'b10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: a=11, b=00 (Greater)", test_num);
            a <= 2'b11;
            b <= 2'b00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("comparator2bit Testbench");
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
        input expected_a_eq_b;
        input expected_a_gt_b;
        input expected_a_lt_b;
        begin
            if (expected_a_eq_b === (expected_a_eq_b ^ a_eq_b ^ expected_a_eq_b) &&
                expected_a_gt_b === (expected_a_gt_b ^ a_gt_b ^ expected_a_gt_b) &&
                expected_a_lt_b === (expected_a_lt_b ^ a_lt_b ^ expected_a_lt_b)) begin
                $display("PASS");
                $display("  Outputs: a_eq_b=%b, a_gt_b=%b, a_lt_b=%b",
                         a_eq_b, a_gt_b, a_lt_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a_eq_b=%b, a_gt_b=%b, a_lt_b=%b",
                         expected_a_eq_b, expected_a_gt_b, expected_a_lt_b);
                $display("  Got:      a_eq_b=%b, a_gt_b=%b, a_lt_b=%b",
                         a_eq_b, a_gt_b, a_lt_b);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,a, b, clk, a_eq_b, a_gt_b, a_lt_b);
    end

endmodule
