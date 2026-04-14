`timescale 1ns/1ps

module csprng_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [3:0] random_number;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    csprng dut (
        .clk(clk),
        .reset(reset),
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
            @(posedge clk);
            #1;
            reset = 0;

        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checking initial state after reset...", test_num);
            reset_dut();

            #1;


            check_outputs(4'h1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checking sequence after 1 clock cycle...", test_num);
            reset_dut();
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'h2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checking sequence after 3 clock cycles...", test_num);
            reset_dut();
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(4'h9);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checking repeatability (Reset and run)...", test_num);


            reset_dut();
            repeat(5) @(posedge clk);


            reset_dut();
            repeat(5) @(posedge clk);
            #1;


            #1;



            check_outputs(4'h6);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checking sequence after 15 cycles (Full Period)...", test_num);
            reset_dut();

            repeat(15) @(posedge clk);
            #1;

            #1;


            check_outputs(4'h1);
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
        input [3:0] expected_random_number;
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
        $dumpvars(0,clk, reset, random_number);
    end

endmodule
