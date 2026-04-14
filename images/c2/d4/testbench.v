`timescale 1ns/1ps

module fibonacci_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fibonacci dut (
        .clk(clk),
        .reset(reset),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #2;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Checking 1st number (should be 1)", test_num);
            reset_dut();
            @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Checking 2nd number (should be 1)", test_num);
            reset_dut();
            repeat(2) @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Checking 6th number (should be 8)", test_num);
            reset_dut();
            repeat(6) @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(8'd8);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Checking 11th number (should be 89)", test_num);
            reset_dut();
            repeat(11) @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(8'd89);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Checking 12th number (should be 144)", test_num);
            reset_dut();
            repeat(12) @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(8'd144);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Checking 13th number (Restart, should be 1)", test_num);
            reset_dut();
            repeat(13) @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Checking 24th number (End of 2nd loop, should be 144)", test_num);
            reset_dut();
            repeat(24) @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(8'd144);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Checking mid-sequence reset", test_num);
            reset_dut();
            repeat(5) @(posedge clk);
            reset_dut();
            @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(8'd1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fibonacci Testbench");
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
        input [7:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, reset, out);
    end

endmodule
