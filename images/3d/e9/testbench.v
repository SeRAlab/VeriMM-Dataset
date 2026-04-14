`timescale 1ns/1ps

module rng_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    reg [7:0] seed;
    wire [7:0] random_number;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rng dut (
        .clk(clk),
        .rst_n(rst_n),
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
            rst_n = 0;
            seed = 8'h01;
            repeat (2) @(posedge clk);
            #2 rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initialization with Seed 0x01", test_num);
            rst_n = 0;
            seed = 8'h01;
            #20 rst_n = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initialization with Seed 0xA5", test_num);
            rst_n = 0;
            seed = 8'hA5;
            #20 rst_n = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Step Transition (0x01 -> 0x02)", test_num);
            reset_dut();
            @(posedge clk);
            #1 #1;
 check_outputs(8'h02);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 8-Cycle Transition (Feedback Logic Check)", test_num);
            reset_dut();
            repeat (8) @(posedge clk);
            #1 #1;
 check_outputs(8'h1D);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Mid-Operation", test_num);
            reset_dut();
            repeat (10) @(posedge clk);
            rst_n = 0;
            #20 rst_n = 1;
            seed = 8'h01;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h01);
        end
        endtask

    task testcase006;

        reg [7:0] val1;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Divergence Check (Different Seeds)", test_num);


            rst_n = 0; seed = 8'h01; #20 rst_n = 1;
            @(posedge clk); @(posedge clk);
            val1 = random_number;


            rst_n = 0; seed = 8'h02; #20 rst_n = 1;
            @(posedge clk); @(posedge clk);

            if (random_number != val1) begin
                pass_count = pass_count + 1;
                $display("PASS: Seed 0x01 and 0x02 produced different sequences.");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: RNG produced identical sequences for different seeds.");
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
        $display("rng Testbench");
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
        $dumpvars(0,clk, rst_n, seed, random_number);
    end

endmodule
