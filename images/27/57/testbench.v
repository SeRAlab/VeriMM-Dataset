`timescale 1ns/1ps

module noise_suppression_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] noise_in;
    reg reset;
    wire [4:0] clean_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    noise_suppression dut (
        .clk(clk),
        .noise_in(noise_in),
        .reset(reset),
        .clean_out(clean_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        noise_in = 5'b0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reset State Check", test_num);
        reset_dut();
        #1;

        check_outputs(5'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Stable Input Update (3 cycles)", test_num);
        reset_dut();
        noise_in = 5'h1F;
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(5'h1F);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: 1-Cycle Noise Suppression", test_num);
        reset_dut();
        noise_in = 5'h0A;
        @(posedge clk);
        noise_in = 5'h00;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(5'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: 2-Cycle Noise Suppression", test_num);
        reset_dut();
        noise_in = 5'h15;
        repeat(2) @(posedge clk);
        noise_in = 5'h00;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Transition Between Stable Values", test_num);
        reset_dut();

        noise_in = 5'h1F;
        repeat(3) @(posedge clk);

        noise_in = 5'h05;
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(5'h05);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Interrupted Change Suppression", test_num);
        reset_dut();
        noise_in = 5'h11;
        repeat(2) @(posedge clk);
        noise_in = 5'h02;
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(5'h02);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("noise_suppression Testbench");
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
        input [4:0] expected_clean_out;
        begin
            if (expected_clean_out === (expected_clean_out ^ clean_out ^ expected_clean_out)) begin
                $display("PASS");
                $display("  Outputs: clean_out=%h",
                         clean_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clean_out=%h",
                         expected_clean_out);
                $display("  Got:      clean_out=%h",
                         clean_out);
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
        $dumpvars(0,clk, noise_in, reset, clean_out);
    end

endmodule
