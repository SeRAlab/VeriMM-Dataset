`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg din;
    reg [31:0] term_hits;
    reg wrenb;
    wire [3:0] dout_pair;
    wire [7:0] pair_sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .term_hits(term_hits),
        .wrenb(wrenb),
        .dout_pair(dout_pair),
        .pair_sum(pair_sum)
    );
    task reset_inputs;

        begin
            term_hits = 32'h0;
            wrenb = 0;
            din = 0;
            @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeroes", test_num);
            reset_inputs();

            term_hits = 32'h0000_0000;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(4'h0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            reset_inputs();

            term_hits = 32'hFFFF_FFFF;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(4'h8, 8'h20);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits 55555555", test_num);
            reset_inputs();

            term_hits = 32'h5555_5555;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(4'h4, 8'h10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits AAAAAAAA", test_num);
            reset_inputs();

            term_hits = 32'hAAAA_AAAA;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(4'h4, 8'h10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Lower 16 Bits Set", test_num);
            reset_inputs();

            term_hits = 32'h0000_FFFF;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(4'h8, 8'h10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Upper 16 Bits Set", test_num);
            reset_inputs();

            term_hits = 32'hFFFF_0000;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(4'h0, 8'h10);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Bit (Bit 0)", test_num);
            reset_inputs();

            term_hits = 32'h0000_0001;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(4'h1, 8'h01);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Bit (Bit 31)", test_num);
            reset_inputs();

            term_hits = 32'h8000_0000;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(4'h0, 8'h01);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Wrenb and Din Activity", test_num);
            reset_inputs();

            wrenb = 1;
            din = 1;
            @(posedge clk);
            wrenb = 0;
            term_hits = 32'h0000_0003;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(4'h2, 8'h02);
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
        input [3:0] expected_dout_pair;
        input [7:0] expected_pair_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout_pair === (expected_dout_pair ^ dout_pair ^ expected_dout_pair) &&
                expected_pair_sum === (expected_pair_sum ^ pair_sum ^ expected_pair_sum)) begin
                $display("PASS");
                $display("  Outputs: dout_pair=%h, pair_sum=%h",
                         dout_pair, pair_sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout_pair=%h, pair_sum=%h",
                         expected_dout_pair, expected_pair_sum);
                $display("  Got:      dout_pair=%h, pair_sum=%h",
                         dout_pair, pair_sum);
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
