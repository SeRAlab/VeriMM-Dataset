`timescale 1ns/1ps

module csprng_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [4:0] seed;
    wire [4:0] rand_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    csprng dut (
        .clk(clk),
        .reset(reset),
        .seed(seed),
        .rand_out(rand_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        input [4:0] s;
        begin
            @(negedge clk);
            reset = 1;
            seed = s;
            @(negedge clk);
            reset = 0;

            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load Seed 5'h01", test_num);
            reset_dut(5'h01);

            #1;


            check_outputs(5'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift after 1 cycle (Seed 5'h01)", test_num);
            reset_dut(5'h01);
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h02);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift after 3 cycles (Seed 5'h01)", test_num);
            reset_dut(5'h01);
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h09);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift after 1 cycle (Seed 5'h1F)", test_num);
            reset_dut(5'h1F);
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h1E);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift after 2 cycles (Seed 5'h0A)", test_num);
            reset_dut(5'h0A);
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h08);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Seed Lock-up Check", test_num);
            reset_dut(5'h00);
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("csprng Testbench");
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
        input [4:0] expected_rand_out;
        begin
            if (expected_rand_out === (expected_rand_out ^ rand_out ^ expected_rand_out)) begin
                $display("PASS");
                $display("  Outputs: rand_out=%h",
                         rand_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rand_out=%h",
                         expected_rand_out);
                $display("  Got:      rand_out=%h",
                         rand_out);
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
        $dumpvars(0,clk, reset, seed, rand_out);
    end

endmodule
