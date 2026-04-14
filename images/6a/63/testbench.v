`timescale 1ns/1ps

module reg_4bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] d;
    reg rst;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_4bit dut (
        .clk(clk),
        .d(d),
        .rst(rst),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            d = 4'b0000;
            #12;
            rst = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power-on Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Data Load (4'hA)", test_num);
            reset_dut();
            @(negedge clk);
            d = 4'hA;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwriting Data (4'h5 -> 4'hF)", test_num);
            reset_dut();
            @(negedge clk); d = 4'h5;
            @(posedge clk);
            @(negedge clk); d = 4'hF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Asynchronous Reset Mid-Cycle", test_num);
            reset_dut();
            @(negedge clk);
            d = 4'h7;
            @(posedge clk);
            #2;


            #3;
            rst = 1;
            #1;
            #1;

            check_outputs(4'h0);
            rst = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Stability (No Clock Edge)", test_num);
            reset_dut();
            @(negedge clk);
            d = 4'h3;
            @(posedge clk);
            #2;

            @(negedge clk);
            d = 4'hE;
            #1;
            #1;

            check_outputs(4'h3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg_4bit Testbench");
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
        input [3:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, d, rst, q);
    end

endmodule
