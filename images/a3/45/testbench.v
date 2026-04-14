`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] wi;
    reg [127:0] xi;
    wire [1:0] cout;
    wire [31:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .wi(wi),
        .xi(xi),
        .cout(cout),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = 1;
        xi = 128'h0;
        wi = 128'h0;

        exp_xnor = xi ~^ wi;
        exp_inter_sum = exp_xnor[63:0] + exp_xnor[127:64];
        exp_cout_val = exp_inter_sum[64:63];
        exp_sum_val  = exp_inter_sum[31:0];

        $display("Test %0d: All Zeros input", test_num);
        #1;

        check_outputs(exp_cout_val, exp_sum_val);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        xi = {128{1'b1}};
        wi = {128{1'b1}};

        exp_xnor = xi ~^ wi;
        exp_inter_sum = exp_xnor[63:0] + exp_xnor[127:64];
        exp_cout_val = exp_inter_sum[64:63];
        exp_sum_val  = exp_inter_sum[31:0];

        $display("Test %0d: All Ones input", test_num);
        #1;

        check_outputs(exp_cout_val, exp_sum_val);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        xi = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
        wi = 128'h55555555555555555555555555555555;

        exp_xnor = xi ~^ wi;
        exp_inter_sum = exp_xnor[63:0] + exp_xnor[127:64];
        exp_cout_val = exp_inter_sum[64:63];
        exp_sum_val  = exp_inter_sum[31:0];

        $display("Test %0d: Complementary inputs", test_num);
        #1;

        check_outputs(exp_cout_val, exp_sum_val);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        xi = 128'h123456789ABCDEF00FEDCBA987654321;
        wi = 128'hFFFFFFFFFFFFFFFF0000000000000000;

        exp_xnor = xi ~^ wi;
        exp_inter_sum = exp_xnor[63:0] + exp_xnor[127:64];
        exp_cout_val = exp_inter_sum[64:63];
        exp_sum_val  = exp_inter_sum[31:0];

        $display("Test %0d: Random pattern 1", test_num);
        #1;

        check_outputs(exp_cout_val, exp_sum_val);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;

        xi = 128'h0;
        wi = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

        xi = 128'h80000000000000008000000000000000;
        wi = 128'h80000000000000008000000000000000;

        exp_xnor = xi ~^ wi;
        exp_inter_sum = exp_xnor[63:0] + exp_xnor[127:64];
        exp_cout_val = exp_inter_sum[64:63];
        exp_sum_val  = exp_inter_sum[31:0];

        $display("Test %0d: Carry trigger test", test_num);
        #1;

        check_outputs(exp_cout_val, exp_sum_val);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        xi = 128'hA5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5;
        wi = 128'h5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A;

        exp_xnor = xi ~^ wi;
        exp_inter_sum = exp_xnor[63:0] + exp_xnor[127:64];
        exp_cout_val = exp_inter_sum[64:63];
        exp_sum_val  = exp_inter_sum[31:0];

        $display("Test %0d: Alternating nibbles", test_num);
        #1;

        check_outputs(exp_cout_val, exp_sum_val);
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
        input [1:0] expected_cout;
        input [31:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: cout=%h, sum=%h",
                         cout, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%h, sum=%h",
                         expected_cout, expected_sum);
                $display("  Got:      cout=%h, sum=%h",
                         cout, sum);
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
