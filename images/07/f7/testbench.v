`timescale 1ns/1ps

module DVFS_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] load;
    wire [1:0] freq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DVFS_Controller dut (
        .clk(clk),
        .load(load),
        .freq(freq)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load = 4'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Low Load Boundary (0)", test_num);
            reset_dut();
            load = 4'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Low Load Boundary (3)", test_num);
            reset_dut();
            load = 4'd3;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Medium Load Boundary (4)", test_num);
            reset_dut();
            load = 4'd4;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Medium Load Boundary (6)", test_num);
            reset_dut();
            load = 4'd6;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: High Load Boundary (7)", test_num);
            reset_dut();
            load = 4'd7;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: High Load Boundary (15)", test_num);
            reset_dut();
            load = 4'd15;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: High to Medium Transition", test_num);
            reset_dut();
            load = 4'd10;
            @(posedge clk);
            #1;
            load = 4'd5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Low to High Transition", test_num);
            reset_dut();
            load = 4'd1;
            @(posedge clk);
            #1;
            load = 4'd12;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b11);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DVFS_Controller Testbench");
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
        input [1:0] expected_freq;
        begin
            if (expected_freq === (expected_freq ^ freq ^ expected_freq)) begin
                $display("PASS");
                $display("  Outputs: freq=%h",
                         freq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: freq=%h",
                         expected_freq);
                $display("  Got:      freq=%h",
                         freq);
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
        $dumpvars(0,clk, load, freq);
    end

endmodule
