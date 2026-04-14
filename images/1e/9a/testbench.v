`timescale 1ns/1ps

module lfsr_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [31:0] lfsr_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lfsr_32bit dut (
        .clk(clk),
        .reset(reset),
        .lfsr_out(lfsr_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("\nResetting DUT...");
            reset = 1;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying Reset Seed", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0000_0001);
        end
        endtask

    task testcase002;

        reg [31:0] expected;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying Single Transition", test_num);
            reset_dut();

            expected = 32'h0000_0001;
            expected = get_next_lfsr(expected);


            @(posedge clk);
            #2;
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase003;

        reg [31:0] expected;
        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying 10 Transitions", test_num);
            reset_dut();

            expected = 32'h0000_0001;
            for (i = 0; i < 10; i = i + 1) begin
                expected = get_next_lfsr(expected);
                @(posedge clk);
            end
            #2;
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase004;

        reg [31:0] expected;
        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying 100 Transitions", test_num);
            reset_dut();

            expected = 32'h0000_0001;
            for (i = 0; i < 100; i = i + 1) begin
                expected = get_next_lfsr(expected);
                @(posedge clk);
            end
            #2;
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying Mid-operation Reset", test_num);
            reset_dut();


            repeat(50) @(posedge clk);


            reset_dut();


            #1;



            check_outputs(32'h0000_0001);
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
        $dumpvars(0,clk, reset, lfsr_out);
    end

endmodule
