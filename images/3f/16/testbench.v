`timescale 1ns/1ps

module csprng_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [3:0] seed;
    wire [3:0] random_number;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    csprng dut (
        .clk(clk),
        .rst(rst),
        .seed(seed),
        .random_number(random_number)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        input [3:0] s;
        begin
            seed = s;
            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;

        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verify seed load (8)", test_num);
            reset_dut(4'b1000);
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single transition from seed 8", test_num);
            reset_dut(4'b1000);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: 5 transitions from seed 8", test_num);
            reset_dut(4'b1000);
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Transition from seed 5 (0101)", test_num);
            reset_dut(4'b0101);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Full period (15 cycles) check", test_num);
            reset_dut(4'b1100);
            repeat(15) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Transition from all-ones (1111)", test_num);
            reset_dut(4'b1111);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1110);
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
        $dumpvars(0,clk, rst, seed, random_number);
    end

endmodule
