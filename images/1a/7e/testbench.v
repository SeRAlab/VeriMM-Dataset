`timescale 1ns/1ps

module pll_8x_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg rst;
    wire clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pll_8x dut (
        .clk_in(clk_in),
        .rst(rst),
        .clk_out(clk_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            rst = 1;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        integer edge_count;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Frequency Check (Expect 8x)", test_num);
            reset_dut();


            #(200);

            edge_count = 0;
            @(posedge clk_in);




            fork
                begin
                    repeat (10) @(posedge clk_in);
                end
                begin
                    forever @(posedge clk_out) edge_count = edge_count + 1;
                end
            join_any
            disable fork;


            if (edge_count >= 79 && edge_count <= 81) begin
                $display("  Measured %0d edges in 10 input cycles. Frequency is correct.", edge_count);
                #1;

                check_outputs(clk_out);
            end else begin
                $display("  Measured %0d edges in 10 input cycles. Expected ~80.", edge_count);
                #1;

                check_outputs(!clk_out);
            end
        end
        endtask

    task testcase002;

        integer edge_count;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mid-run Reset Recovery", test_num);
            reset_dut();

            #(100);


            rst = 1;
            #(50);


            if (clk_out === 1'b1 || clk_out === 1'b0 || clk_out === 1'bz) begin

                rst = 0;
                #(200);

                edge_count = 0;
                @(posedge clk_in);
                fork
                    begin
                        repeat (5) @(posedge clk_in);
                    end
                    begin
                        forever @(posedge clk_out) edge_count = edge_count + 1;
                    end
                join_any
                disable fork;


                if (edge_count >= 39 && edge_count <= 41) begin
                    $display("  PLL recovered correctly after reset. Measured %0d edges.", edge_count);
                    #1;

                    check_outputs(clk_out);
                end else begin
                    $display("  PLL failed to recover. Measured %0d edges.", edge_count);
                    #1;

                    check_outputs(!clk_out);
                end
            end else begin
                $display("  Invalid state during reset.");
                #1;

                check_outputs(!clk_out);
            end
        end
        endtask

    task testcase003;

        integer edge_count;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Long-term Stability Check", test_num);
            reset_dut();

            #(1000);

            edge_count = 0;
            @(posedge clk_in);
            fork
                begin
                    repeat (50) @(posedge clk_in);
                end
                begin
                    forever @(posedge clk_out) edge_count = edge_count + 1;
                end
            join_any
            disable fork;


            if (edge_count >= 398 && edge_count <= 402) begin
                $display("  Stable operation confirmed. Measured %0d edges.", edge_count);
                #1;

                check_outputs(clk_out);
            end else begin
                $display("  Instability detected. Measured %0d edges.", edge_count);
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
        $display("pll_8x Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        
        
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
        $dumpvars(0,clk_in, rst, clk_out);
    end

endmodule
