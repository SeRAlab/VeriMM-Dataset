`timescale 1ns/1ps

module fractional_n_pll_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] freq_in;
    wire [3:0] freq_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fractional_n_pll dut (
        .clk(clk),
        .freq_in(freq_in),
        .freq_out(freq_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            freq_in <= 4'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 2 (Simple integer result)", test_num);
            reset_dut();
            freq_in <= 4'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 4", test_num);
            reset_dut();
            freq_in <= 4'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 8", test_num);
            reset_dut();
            freq_in <= 4'd8;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd12);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 10 (Boundary of 4-bit max)", test_num);
            reset_dut();
            freq_in <= 4'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 1 (Fractional floor check)", test_num);
            reset_dut();
            freq_in <= 4'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 3 (Fractional floor check)", test_num);
            reset_dut();
            freq_in <= 4'd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 12 (Overflow check: 18 mod 16)", test_num);
            reset_dut();
            freq_in <= 4'd12;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 15 (Max input: 22.5 floor/overflow check)", test_num);
            reset_dut();
            freq_in <= 4'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd6);
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
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [3:0] expected_freq_out;
        begin
            if (expected_freq_out === (expected_freq_out ^ freq_out ^ expected_freq_out)) begin
                $display("PASS");
                $display("  Outputs: freq_out=%h",
                         freq_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: freq_out=%h",
                         expected_freq_out);
                $display("  Got:      freq_out=%h",
                         freq_out);
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
        $dumpvars(0,clk, freq_in, freq_out);
    end

endmodule
