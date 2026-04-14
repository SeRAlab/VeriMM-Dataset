`timescale 1ns/1ps

module lfsr_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [31:0] seed;
    wire [31:0] lfsr_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lfsr_32bit dut (
        .clk(clk),
        .reset(reset),
        .seed(seed),
        .lfsr_out(lfsr_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Reset and Seed loading", test_num);
            seed = 32'hACE1ACE1;
            reset_dut();

            #1;


            check_outputs(32'hACE1ACE1);
        end
        endtask

    task testcase002;

        reg [31:0] expected;
        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Single transition check", test_num);
            seed = 32'h12345678;
            reset_dut();

            expected = get_next_lfsr(32'h12345678);

            @(posedge clk);
            #1;
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase003;

        reg [31:0] expected;
        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTest %0d: 10-cycle sequence check", test_num);
            seed = 32'hFFFFFFFF;
            reset_dut();

            expected = 32'hFFFFFFFF;
            for (i = 0; i < 10; i = i + 1) begin
                expected = get_next_lfsr(expected);
                @(posedge clk);
            end

            #1;
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase004;

        reg [31:0] expected;
        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTest %0d: 100-cycle sequence check with different seed", test_num);
            seed = 32'h00000001;
            reset_dut();

            expected = 32'h00000001;
            for (i = 0; i < 100; i = i + 1) begin
                expected = get_next_lfsr(expected);
                @(posedge clk);
            end

            #1;
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Reset mid-sequence", test_num);
            seed = 32'h55AA55AA;
            reset_dut();


            repeat(5) @(posedge clk);


            seed = 32'hDEADBEEF;
            reset_dut();

            #1;


            check_outputs(32'hDEADBEEF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lfsr_32bit Testbench");
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
        input [31:0] expected_lfsr_out;
        begin
            if (expected_lfsr_out === (expected_lfsr_out ^ lfsr_out ^ expected_lfsr_out)) begin
                $display("PASS");
                $display("  Outputs: lfsr_out=%h",
                         lfsr_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lfsr_out=%h",
                         expected_lfsr_out);
                $display("  Got:      lfsr_out=%h",
                         lfsr_out);
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
        $dumpvars(0,clk, reset, seed, lfsr_out);
    end

endmodule
