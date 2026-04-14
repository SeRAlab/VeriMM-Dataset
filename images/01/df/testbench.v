`timescale 1ns/1ps

module rng_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [2:0] seed;
    wire [4:0] output_r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rng dut (
        .clk(clk),
        .reset(reset),
        .seed(seed),
        .output_r(output_r)
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
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset with Seed 1", test_num);
            seed = 3'b001;
            reset_dut();

            #1;


            check_outputs(5'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset with Seed 5", test_num);
            seed = 3'b101;
            reset_dut();

            #1;


            check_outputs(5'h05);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition after 1 cycle (Seed 1)", test_num);
            seed = 3'b001;
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h02);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition after 3 cycles (Seed 1)", test_num);
            seed = 3'b001;
            reset_dut();
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h09);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition after 5 cycles (Seed 4)", test_num);
            seed = 3'b100;
            reset_dut();
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h14);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mid-sequence Reset", test_num);
            seed = 3'b001;
            reset_dut();
            repeat(10) @(posedge clk);
            seed = 3'b011;
            reset_dut();
            #1;

            check_outputs(5'h03);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rng Testbench");
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
        input [4:0] expected_output_r;
        begin
            if (expected_output_r === (expected_output_r ^ output_r ^ expected_output_r)) begin
                $display("PASS");
                $display("  Outputs: output_r=%h",
                         output_r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_r=%h",
                         expected_output_r);
                $display("  Got:      output_r=%h",
                         output_r);
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
        $dumpvars(0,clk, reset, seed, output_r);
    end

endmodule
