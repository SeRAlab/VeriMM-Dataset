`timescale 1ns/1ps

module lfsr_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [15:0] seed;
    wire [15:0] lfsr_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lfsr dut (
        .clk(clk),
        .load(load),
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
            @(posedge clk);
            load <= 1;
            seed <= 16'h0000;
            @(posedge clk);
            load <= 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Load", test_num);
            @(posedge clk);
            load <= 1;
            seed <= 16'hACE1;
            @(posedge clk);
            load <= 0;
            #1;

            check_outputs(16'hACE1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Left (XOR 1^0=1)", test_num);
            reset_dut();
            load <= 1;
            seed <= 16'h8000;
            @(posedge clk);
            load <= 0;
            @(posedge clk);
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Left (XOR 0^1=1)", test_num);
            reset_dut();
            load <= 1;
            seed <= 16'h2000;
            @(posedge clk);
            load <= 0;
            @(posedge clk);
            #1;

            check_outputs(16'h4001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Left (XOR 1^1=0)", test_num);
            reset_dut();
            load <= 1;
            seed <= 16'hA000;
            @(posedge clk);
            load <= 0;
            @(posedge clk);
            #1;

            check_outputs(16'h4000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Two consecutive shifts", test_num);
            reset_dut();
            load <= 1;
            seed <= 16'h1234;
            @(posedge clk);
            load <= 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'h48D1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift from All Ones", test_num);
            reset_dut();
            load <= 1;
            seed <= 16'hFFFF;
            @(posedge clk);
            load <= 0;
            @(posedge clk);
            #1;

            check_outputs(16'hFFFE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Lock state (all zeros)", test_num);
            reset_dut();
            load <= 1;
            seed <= 16'h0000;
            @(posedge clk);
            load <= 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lfsr Testbench");
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
        input [15:0] expected_lfsr_out;
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
        $dumpvars(0,clk, load, seed, lfsr_out);
    end

endmodule
