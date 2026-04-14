`timescale 1ns/1ps

module CSPRNG_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] seed;
    wire [7:0] random_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    CSPRNG dut (
        .clk(clk),
        .reset(reset),
        .seed(seed),
        .random_out(random_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            seed = 8'h00;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initial Seed 0x01", test_num);
            reset_dut();
            seed = 8'h01;
            @(posedge clk);
            #1;

            if (random_out != 8'h00) begin
                $display("PASS: random_out is non-zero (%h)", random_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: random_out is zero");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Repeatability Check", test_num);


            reset_dut();
            seed = 8'hA5;
            repeat(2) @(posedge clk);
            #1 capture_val1 = random_out;


            reset_dut();
            seed = 8'hA5;
            repeat(2) @(posedge clk);
            #1 capture_val2 = random_out;

            #1;


            check_outputs(capture_val1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Seed Sensitivity Check", test_num);

            reset_dut();
            seed = 8'hAA;
            @(posedge clk);
            #1 capture_val1 = random_out;

            reset_dut();
            seed = 8'h55;
            @(posedge clk);
            #1 capture_val2 = random_out;

            if (capture_val1 != capture_val2) begin
                $display("PASS: Different seeds produced different outputs (%h != %h)", capture_val1, capture_val2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Different seeds produced identical output (%h)", capture_val1);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sequence Progression Check", test_num);
            reset_dut();
            seed = 8'hF0;
            @(posedge clk);
            #1 capture_val1 = random_out;
            @(posedge clk);
            #1 capture_val2 = random_out;

            if (capture_val1 != capture_val2) begin
                $display("PASS: Sequence is progressing (%h -> %h)", capture_val1, capture_val2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Sequence is stuck at %h", capture_val1);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Long Run Stability", test_num);
            reset_dut();
            seed = 8'h12;
            repeat(20) @(posedge clk);
            #1;
            if (random_out != 8'h00) begin
                $display("PASS: LFSR active after 20 cycles (%h)", random_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: LFSR collapsed to zero after 20 cycles");
                fail_count = fail_count + 1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("CSPRNG Testbench");
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
        input [7:0] expected_random_out;
        begin
            if (expected_random_out === (expected_random_out ^ random_out ^ expected_random_out)) begin
                $display("PASS");
                $display("  Outputs: random_out=%h",
                         random_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: random_out=%h",
                         expected_random_out);
                $display("  Got:      random_out=%h",
                         random_out);
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
        $dumpvars(0,clk, reset, seed, random_out);
    end

endmodule
