`timescale 1ns/1ps

module nfa_accept_samples_generic_hw_mul_8ns_6ns_14_2_MAC2S_1_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [5:0] b;
    reg ce;
    reg clk;
    wire [13:0] p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nfa_accept_samples_generic_hw_mul_8ns_6ns_14_2_MAC2S_1 dut (
        .a(a),
        .b(b),
        .ce(ce),
        .clk(clk),
        .p(p)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a <= 8'd0;
            b <= 6'd0;
            ce <= 1'b0;
            repeat(3) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Simple Multiplication (10 * 5)", test_num);
            reset_dut();
            a <= 8'd10;
            b <= 6'd5;
            ce <= 1'b1;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(14'd50);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Max Values (255 * 63)", test_num);
            reset_dut();
            a <= 8'd255;
            b <= 6'd63;
            ce <= 1'b1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(14'd16065);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Multiplier is Zero", test_num);
            reset_dut();
            a <= 8'd128;
            b <= 6'd0;
            ce <= 1'b1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(14'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Clock Enable Stall Logic", test_num);
            reset_dut();


            a <= 8'd20;
            b <= 6'd3;
            ce <= 1'b1;
            @(posedge clk);



            ce <= 1'b0;
            a <= 8'd100;
            b <= 6'd10;
            repeat(3) @(posedge clk);


            ce <= 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(14'd60);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Power of Two (128 * 32)", test_num);
            reset_dut();
            a <= 8'd128;
            b <= 6'd32;
            ce <= 1'b1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(14'd4096);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nfa_accept_samples_generic_hw_mul_8ns_6ns_14_2_MAC2S_1 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [13:0] expected_p;
        begin
            if (expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: p=%h",
                         p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p=%h",
                         expected_p);
                $display("  Got:      p=%h",
                         p);
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
        $dumpvars(0,a, b, ce, clk, p);
    end

endmodule
