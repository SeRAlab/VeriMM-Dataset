`timescale 1ns/1ps

module register_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg load;
    reg [7:0] parallel_in;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register dut (
        .clear(clear),
        .clk(clk),
        .load(load),
        .parallel_in(parallel_in),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(negedge clk);
        clear = 1;
        load = 0;
        parallel_in = 8'h00;
        @(posedge clk);
        #1;
        clear = 0;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Basic Synchronous Load", test_num);
        @(negedge clk);
        load = 1;
        parallel_in = 8'hA5;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Synchronous Clear (after load)", test_num);

        @(negedge clk);
        load = 1;
        parallel_in = 8'hFF;
        @(posedge clk);

        @(negedge clk);
        load = 0;
        clear = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Hold Value (load=0, clear=0)", test_num);

        @(negedge clk);
        load = 1;
        parallel_in = 8'h5A;
        @(posedge clk);

        @(negedge clk);
        load = 0;
        parallel_in = 8'h00;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Clear Priority (clear and load high)", test_num);
        @(negedge clk);
        clear = 1;
        load = 1;
        parallel_in = 8'hEE;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: All ones and all zeros", test_num);

        @(negedge clk);
        load = 1;
        parallel_in = 8'hFF;
        @(posedge clk);

        @(negedge clk);
        load = 1;
        parallel_in = 8'h00;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Multiple consecutive loads", test_num);
        @(negedge clk);
        load = 1;
        parallel_in = 8'h11;
        @(posedge clk);
        @(negedge clk);
        parallel_in = 8'h22;
        @(posedge clk);
        @(negedge clk);
        parallel_in = 8'h33;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h33);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [7:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,clear, clk, load, parallel_in, Q);
    end

endmodule
