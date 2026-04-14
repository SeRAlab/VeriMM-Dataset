`timescale 1ns/1ps

module pll_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    wire clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pll dut (
        .clk_in(clk_in),
        .clk_out(clk_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            $display("Resetting/Initializing PLL...");


            #100;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            repeat(20) @(posedge clk_in);
            test_num = 1;
            $display("Running Testcase %03d: Basic Activity Check", test_num);

            if (clk_out === 1'b0 || clk_out === 1'b1)
                #1;

                check_outputs(clk_out);
            else
                #1;

                check_outputs(1'b0);
        end
        endtask

    task testcase002;

        realtime t1, t2;
        realtime measured_period;
        begin
            reset_dut();
            test_num = 2;
            $display("Running Testcase %03d: Frequency Division Check", test_num);


            @(posedge clk_out);
            t1 = $realtime;
            @(posedge clk_out);
            t2 = $realtime;
            measured_period = t2 - t1;



            if (measured_period >= 19.9 && measured_period <= 20.1) begin
                $display("  Measured Period: %0f ns (Correct)", measured_period);
                #1;

                check_outputs(1'b1);
            end else begin
                $display("  Measured Period: %0f ns (Incorrect, expected 20ns)", measured_period);
                #1;

                check_outputs(!clk_out);
            end
        end
        endtask

    task testcase003;

        realtime t_start, t_end;
        realtime high_width;
        begin
            reset_dut();
            test_num = 3;
            $display("Running Testcase %03d: Duty Cycle Check", test_num);

            @(posedge clk_out);
            t_start = $realtime;
            @(negedge clk_out);
            t_end = $realtime;
            high_width = t_end - t_start;

            if (high_width >= 9.9 && high_width <= 10.1) begin
                $display("  Measured High Width: %0f ns (Correct)", high_width);
                #1;

                check_outputs(1'b0);
            end else begin
                $display("  Measured High Width: %0f ns (Incorrect, expected 10ns)", high_width);
                #1;

                check_outputs(1'b1);
            end
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Running Testcase %03d: Long-term Stability Check", test_num);


            #5000;


            fork
                begin
                    @(posedge clk_out);
                    #1;

                    check_outputs(1'b1);
                end
                begin
                    #100;
                    $display("  Error: Clock stopped toggling!");
                    #1;

                    check_outputs(!clk_out);
                end
            join_any
            disable fork;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pll Testbench");
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
        $dumpvars(0,clk_in, clk_out);
    end

endmodule
