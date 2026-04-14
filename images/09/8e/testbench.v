`timescale 1ns/1ps

module CSPRNG_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [15:0] seed;
    wire [15:0] random_out;

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
            #10;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset Initialization", test_num);
            seed = 16'hACE1;
            reset_dut();

            #1;


            check_outputs(16'hACE1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Single Step Transition", test_num);
            seed = 16'h0001;
            reset_dut();

            @(posedge clk);
            #1;



            #1;




            check_outputs(16'h0002);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Multiple Step Transition", test_num);
            seed = 16'h0001;
            reset_dut();

            repeat(4) @(posedge clk);
            #1;


            #1;



            check_outputs(16'h0010);
        end
        endtask

    task testcase004;

        reg [15:0] first_run_val;
        begin
            test_num = 4;
            $display("\nTestcase %0d: Repeatability Check", test_num);
            seed = 16'hBEEF;


            reset_dut();
            repeat(10) @(posedge clk);
            first_run_val = random_out;


            reset_dut();
            repeat(10) @(posedge clk);

            #1;


            check_outputs(first_run_val);
        end
        endtask

    task testcase005;

        reg [15:0] seed1_val;
        begin
            test_num = 5;
            $display("\nTestcase %0d: Seed Divergence Check", test_num);


            seed = 16'h1234;
            reset_dut();
            repeat(5) @(posedge clk);
            seed1_val = random_out;


            seed = 16'h4321;
            reset_dut();
            repeat(5) @(posedge clk);


            if (random_out !== seed1_val) begin
                $display("PASS: Seeds diverged as expected.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Different seeds produced identical output.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: High Bit Feedback Logic", test_num);
            seed = 16'h8000;
            reset_dut();

            @(posedge clk);
            #1;





            if (random_out != 16'h0000) begin
                $display("PASS: LFSR evolved from MSB-only seed.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: LFSR collapsed to zero.");
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
        input [15:0] expected_random_out;
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
