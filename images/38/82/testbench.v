`timescale 1ns/1ps

module mersenne_twister_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [31:0] seed;
    wire [31:0] random_number;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mersenne_twister dut (
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

        input [31:0] s;
        begin
            @(posedge clk);
            rst = 1;
            seed = s;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Initialization with Seed 0", test_num);
            reset_dut(32'h0000_0000);


            repeat(10) @(posedge clk);




            if (random_number !== 32'hx && random_number !== 32'hz) begin
                $display("Status: Module is generating data.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Module output is invalid (X or Z)");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase002;

        reg [31:0] first_val;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Testing Seed 0xDEADBEEF", test_num);
            reset_dut(32'hDEADBEEF);

            repeat(5) @(posedge clk);
            first_val = random_number;


            if (first_val != 0) begin
                $display("Status: Generated value %h", first_val);
                pass_count = pass_count + 1;
            } else {
                $display("FAIL: Generated zero or unexpected value");
                fail_count = fail_count + 1;
            }
        end
        endtask

    task testcase003;

        reg [31:0] run1_val;
        reg [31:0] run2_val;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Determinism Check (Repeatability)", test_num);


            reset_dut(32'h12345678);
            repeat(20) @(posedge clk);
            run1_val = random_number;


            reset_dut(32'h12345678);
            repeat(20) @(posedge clk);
            run2_val = random_number;

            if (run1_val === run2_val) begin
                $display("PASS: Deterministic sequence confirmed.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Same seed produced different results (%h vs %h)", run1_val, run2_val);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        reg [31:0] val_t1;
        reg [31:0] val_t2;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sequence Progression Check", test_num);
            reset_dut(32'hA1B2C3D4);

            @(posedge clk);
            val_t1 = random_number;
            @(posedge clk);
            val_t2 = random_number;

            if (val_t1 != val_t2) begin
                $display("PASS: Values are progressing over time.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Output is stuck at %h", val_t1);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Testing Maximum Seed Value (0xFFFFFFFF)", test_num);
            reset_dut(32'hFFFFFFFF);

            repeat(15) @(posedge clk);


            if (random_number !== 32'hxxxxxxxx) begin
                $display("PASS: Handled max seed correctly.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Output is X");
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
        $display("mersenne_twister Testbench");
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
        input [31:0] expected_random_number;
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
