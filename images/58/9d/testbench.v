`timescale 1ns/1ps

module binary_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst_n;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_counter dut (
        .clk(clk),
        .en(en),
        .rst_n(rst_n),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            en = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Reset", test_num);
            reset_dut();


            #1;



            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Increment", test_num);
            reset_dut();
            en = 1;
            @(posedge clk);
            #1 en = 0;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiple Increments (10)", test_num);
            reset_dut();
            en = 1;
            repeat(10) @(posedge clk);
            #1 en = 0;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Enable Gating (Pause Counting)", test_num);
            reset_dut();
            en = 1;
            repeat(5) @(posedge clk);
            en = 0;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(4'h5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Counter Rollover (15 to 0)", test_num);
            reset_dut();
            en = 1;
            repeat(16) @(posedge clk);
            #1 en = 0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Rollover and Continue (Count to 18)", test_num);
            reset_dut();
            en = 1;
            repeat(18) @(posedge clk);
            #1 en = 0;
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Overrides Enable", test_num);
            reset_dut();
            en = 1;
            repeat(5) @(posedge clk);
            rst_n = 0;
            @(posedge clk);
            #1 rst_n = 1;
            en = 0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_counter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [3:0] expected_out;
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
        $dumpvars(0,clk, en, rst_n, out);
    end

endmodule
