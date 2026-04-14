`timescale 1ns/1ps

module csprng_lfsr_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [15:0] seed;
    wire random_bit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    csprng_lfsr dut (
        .clk(clk),
        .rst(rst),
        .seed(seed),
        .random_bit(random_bit)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        input [15:0] s;
        begin
            @(negedge clk);
            rst = 1;
            seed = s;
            @(negedge clk);
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut(16'h8000);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut(16'h8000);
            @(posedge clk);
            #1;



            #1;




            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            reset_dut(16'h8001);
            repeat (16) @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut(16'hACE1);
            repeat (5) @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut(16'h0001);
            repeat (2) @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("csprng_lfsr Testbench");
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
        input expected_random_bit;
        begin
            if (expected_random_bit === (expected_random_bit ^ random_bit ^ expected_random_bit)) begin
                $display("PASS");
                $display("  Outputs: random_bit=%b",
                         random_bit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: random_bit=%b",
                         expected_random_bit);
                $display("  Got:      random_bit=%b",
                         random_bit);
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
        $dumpvars(0,clk, rst, seed, random_bit);
    end

endmodule
