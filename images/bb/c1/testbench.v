`timescale 1ns/1ps

module ring_counter_5_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire [4:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ring_counter_5 dut (
        .clk(clk),
        .rst(rst),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            rst <= 1;
            @(posedge clk);
            rst <= 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify state immediately after reset", test_num);
            reset_dut();


            #1;



            check_outputs(5'b00001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify shift after 1 cycle (Expected: 00010)", test_num);
            reset_dut();
            @(posedge clk);
            #1;

            check_outputs(5'b00010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify shift after 2 cycles (Expected: 00100)", test_num);
            reset_dut();
            repeat(2) @(posedge clk);
            #1;

            check_outputs(5'b00100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify shift after 3 cycles (Expected: 01000)", test_num);
            reset_dut();
            repeat(3) @(posedge clk);
            #1;

            check_outputs(5'b01000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify shift after 4 cycles (Expected: 10000)", test_num);
            reset_dut();
            repeat(4) @(posedge clk);
            #1;

            check_outputs(5'b10000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify full loop (5 cycles) (Expected: 00001)", test_num);
            reset_dut();
            repeat(5) @(posedge clk);
            #1;

            check_outputs(5'b00001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify many cycles (13 cycles) (Expected: 01000)", test_num);
            reset_dut();

            repeat(13) @(posedge clk);
            #1;

            check_outputs(5'b01000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify mid-sequence reset behavior", test_num);
            reset_dut();
            repeat(3) @(posedge clk);
            @(posedge clk) rst <= 1;
            @(posedge clk) rst <= 0;
            #1;

            check_outputs(5'b00001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ring_counter_5 Testbench");
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
        input [4:0] expected_Q;
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
        $dumpvars(0,clk, rst, Q);
    end

endmodule
