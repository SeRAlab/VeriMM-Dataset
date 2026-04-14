`timescale 1ns/1ps

module ring_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    wire [3:0] ring;

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
            rst = 0;
            en = 0;
            #15;
            rst = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(4'b0001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Rotation Step", test_num);
            reset_dut();
            @(posedge clk);
            en <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full Rotation Cycle (4 steps)", test_num);
            reset_dut();
            en <= 1;
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable Control (Counting Paused)", test_num);
            reset_dut();
            en <= 0;
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Intermittent Enable Behavior", test_num);
            reset_dut();


            en <= 1;
            repeat(2) @(posedge clk);


            en <= 0;
            repeat(3) @(posedge clk);

            #1;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Asynchronous Reset Mid-Operation", test_num);
            reset_dut();

            en <= 1;
            repeat(3) @(posedge clk);

            #2;
            rst = 0;
            #1;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: MSB to LSB Transition", test_num);
            reset_dut();

            en <= 1;
            repeat(3) @(posedge clk);
            #1;
            if (ring !== 4'b1000) $display("Error: Failed to reach 1000 before final step");

            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0001);
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
        input [3:0] expected_ring;
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
