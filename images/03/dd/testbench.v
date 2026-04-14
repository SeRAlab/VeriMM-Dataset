`timescale 1ns/1ps

module PLL_4x_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg reset;
    wire clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PLL_4x dut (
        .clk_in(clk_in),
        .reset(reset),
        .clk_out(clk_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            reset = 1;
            #20;
            reset = 0;
            #100;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying output during reset", test_num);
            reset = 1;
            #15;

            #1;


            check_outputs(1'b0);
            reset = 0;
            #10;
        end
        endtask

    task testcase002;

        integer edge_count;
        begin
            test_num = 2;
            $display("Testcase %0d: Verifying 4x frequency (4 clk_out cycles per 1 clk_in cycle)", test_num);
            reset_dut();
            edge_count = 0;


            @(posedge clk_in);


            fork
                begin
                    forever @(posedge clk_out) edge_count = edge_count + 1;
                end
                begin
                    #10;
                end
            join_any
            disable fork;


            if (edge_count == 4) begin
                $display("  Frequency check passed: Counted %0d edges", edge_count);
                #1;

                check_outputs(clk_out);
            end else begin
                $display("  Frequency check failed: Counted %0d edges, expected 4", edge_count);
                #1;

                check_outputs(!clk_out);
            end
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verifying 50 percent duty cycle timing", test_num);
            reset_dut();


            @(posedge clk_out);


            #0.625;
            if (clk_out === 1'b1) begin

                #1.25;
                #1;

                check_outputs(1'b0);
            end else begin
                $display("  Duty cycle timing check failed at High phase");
                #1;

                check_outputs(!clk_out);
            end
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verifying long-term stability", test_num);
            reset_dut();


            repeat(50) @(posedge clk_in);



            #0.1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("PLL_4x Testbench");
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
        $dumpvars(0,clk_in, reset, clk_out);
    end

endmodule
