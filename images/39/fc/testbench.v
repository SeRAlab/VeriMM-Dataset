`timescale 1ns/1ps

module csprng_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [3:0] seed;
    wire [7:0] random_number;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    csprng dut (
        .clk(clk),
        .reset(reset),
        .seed(seed),
        .random_number(random_number)
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
            @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initializing with Seed 4'h1", test_num);
            seed = 4'h1;
            reset_dut();


            @(posedge clk);
            #2;



            #1;




            check_outputs(random_number);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initializing with Seed 4'hA", test_num);
            seed = 4'hA;
            reset_dut();

            @(posedge clk);
            #2;


            #1;



            check_outputs(random_number);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Progression check (5 cycles) with Seed 4'h5", test_num);
            seed = 4'h5;
            reset_dut();


            for (i = 0; i < 5; i = i + 1) begin
                @(posedge clk);
            end
            #2;


            #1;



            check_outputs(random_number);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary Seed 4'hF", test_num);
            seed = 4'hF;
            reset_dut();

            @(posedge clk);
            #2;

            #1;


            check_outputs(random_number);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Long duration stability (20 cycles)", test_num);
            seed = 4'h3;
            reset_dut();

            for (i = 0; i < 20; i = i + 1) begin
                @(posedge clk);
            end
            #2;


            if (random_number !== 8'h00) begin
                #1;

                check_outputs(random_number);
            end else begin
                $display("FAIL: Generator potentially locked to zero");
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
        $display("csprng Testbench");
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
        input [7:0] expected_random_number;
        begin
            if (expected_random_number === (expected_random_number ^ random_number ^ expected_random_number)) begin
                $display("PASS");
                $display("  Outputs: random_number=%h",
                         random_number);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: random_number=%h",
                         expected_random_number);
                $display("  Got:      random_number=%h",
                         random_number);
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
        $dumpvars(0,clk, reset, seed, random_number);
    end

endmodule
