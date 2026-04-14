`timescale 1ns/1ps

module fractional_n_pll_tb;

    // Testbench signals (sequential circuit)
    reg clk_ref;
    reg [7:0] frac_val;
    wire clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fractional_n_pll dut (
        .clk_ref(clk_ref),
        .frac_val(frac_val),
        .clk_out(clk_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_ref = 0;
        forever #5 clk_ref = ~clk_ref;
    end

        task reset_dut;

    begin
        frac_val = 8'd0;
        #20;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %03d: Multiplier x2", test_num);
        reset_dut();
        frac_val = 8'd2;


        repeat (5) @(posedge clk_ref);


        edge_count = 0;
        repeat (10) @(posedge clk_ref);



        if (edge_count >= 19 && edge_count <= 21) begin
            @(posedge clk_out); #1;
            #1;

            check_outputs(1'b1);
        end else begin
            $display("  Frequency Error: Expected ~20 edges, Got %0d", edge_count);
            #1;

            check_outputs(!clk_out);
        end
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %03d: Multiplier x4", test_num);
        reset_dut();
        frac_val = 8'd4;

        repeat (5) @(posedge clk_ref);

        edge_count = 0;
        repeat (10) @(posedge clk_ref);


        if (edge_count >= 39 && edge_count <= 41) begin
            @(posedge clk_out); #1;
            #1;

            check_outputs(1'b1);
        end else begin
            $display("  Frequency Error: Expected ~40 edges, Got %0d", edge_count);
            #1;

            check_outputs(!clk_out);
        end
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %03d: Multiplier x1 (Unity)", test_num);
        reset_dut();
        frac_val = 8'd1;

        repeat (5) @(posedge clk_ref);

        edge_count = 0;
        repeat (10) @(posedge clk_ref);

        if (edge_count >= 9 && edge_count <= 11) begin
            @(posedge clk_out); #1;
            #1;

            check_outputs(1'b1);
        end else begin
            $display("  Frequency Error: Expected ~10 edges, Got %0d", edge_count);
            #1;

            check_outputs(!clk_out);
        end
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %03d: Multiplier x10", test_num);
        reset_dut();
        frac_val = 8'd10;

        repeat (5) @(posedge clk_ref);

        edge_count = 0;
        repeat (10) @(posedge clk_ref);

        if (edge_count >= 98 && edge_count <= 102) begin
            @(posedge clk_out); #1;
            #1;

            check_outputs(1'b1);
        end else begin
            $display("  Frequency Error: Expected ~100 edges, Got %0d", edge_count);
            #1;

            check_outputs(!clk_out);
        end
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fractional_n_pll Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_clk_out;
        begin
            if (expected_clk_out === (expected_clk_out ^ clk_out ^ expected_clk_out)) begin
                $display("PASS");
                $display("  Outputs: clk_out=%b",
                         clk_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out=%b",
                         expected_clk_out);
                $display("  Got:      clk_out=%b",
                         clk_out);
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
        $dumpvars(0,clk_ref, frac_val, clk_out);
    end

endmodule
