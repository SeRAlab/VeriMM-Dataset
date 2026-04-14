`timescale 1ns/1ps

module ring_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    wire [5:0] ring;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ring_counter dut (
        .clk(clk),
        .en(en),
        .rst(rst),
        .ring(ring)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            en = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying initial state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(6'b000001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Verifying shift after one cycle", test_num);
            reset_dut();
            en = 1;
            @(posedge clk);
            #1;
            en = 0;

            #1;


            check_outputs(6'b000010);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase %0d: Verifying full wrap-around (6 cycles)", test_num);
            reset_dut();
            en = 1;
            repeat(6) @(posedge clk);
            #1;
            en = 0;

            #1;


            check_outputs(6'b000001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verifying enable/disable (hold value)", test_num);
            reset_dut();
            en = 1;
            repeat(2) @(posedge clk);
            #1;
            en = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(6'b000100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verifying shift to MSB (5 cycles)", test_num);
            reset_dut();
            en = 1;
            repeat(5) @(posedge clk);
            #1;
            en = 0;

            #1;


            check_outputs(6'b100000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Verifying multiple wraps (15 cycles)", test_num);
            reset_dut();
            en = 1;
            repeat(15) @(posedge clk);
            #1;
            en = 0;


            #1;



            check_outputs(6'b001000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Verifying reset priority during operation", test_num);
            reset_dut();
            en = 1;
            repeat(3) @(posedge clk);
            #1;
            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;
            en = 0;

            #1;


            check_outputs(6'b000001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ring_counter Testbench");
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
        input [5:0] expected_ring;
        begin
            if (expected_ring === (expected_ring ^ ring ^ expected_ring)) begin
                $display("PASS");
                $display("  Outputs: ring=%h",
                         ring);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ring=%h",
                         expected_ring);
                $display("  Got:      ring=%h",
                         ring);
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
        $dumpvars(0,clk, en, rst, ring);
    end

endmodule
