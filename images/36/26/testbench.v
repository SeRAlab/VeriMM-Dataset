`timescale 1ns/1ps

module mersenne_twister_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [31:0] seed;
    wire [31:0] random_number;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mersenne_twister dut (
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
            $display("Resetting DUT...");
            reset = 1;
            seed = 32'h0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Initializing with Seed 0x00000001", test_num);
            reset_dut();
            seed = 32'h0000_0001;



            repeat(1000) @(posedge clk);

            store_val1 = random_number;

            if (random_number != 32'h0) begin
                $display("Status: Generator is producing non-zero data.");
                #1;

                check_outputs(random_number);
            end else begin
                $display("Status: FAIL - Generator output stuck at zero.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Repeatability with Seed 0x00000001", test_num);
            reset_dut();
            seed = 32'h0000_0001;

            repeat(1000) @(posedge clk);


            #1;



            check_outputs(store_val1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Different Seed (0xDEADBEEF)", test_num);
            reset_dut();
            seed = 32'hDEAD_BEEF;

            repeat(1000) @(posedge clk);

            if (random_number != store_val1) begin
                $display("Status: Success - Different seed produced different output.");
                pass_count = pass_count + 1;
            end else begin
                $display("Status: FAIL - Different seed produced identical output.");
                fail_count = fail_count + 1;
            end

            #1;


            check_outputs(random_number);
            pass_count = pass_count - 1;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Sequence Progression Check", test_num);
            reset_dut();
            seed = 32'h1234_5678;

            repeat(1000) @(posedge clk);
            store_val2 = random_number;

            repeat(1) @(posedge clk);

            if (random_number != store_val2) begin
                $display("Status: Success - Generator advanced to next random number.");
                pass_count = pass_count + 1;
            end else begin
                $display("Status: FAIL - Generator is stuck on the same number.");
                fail_count = fail_count + 1;
            end
            #1;

            check_outputs(random_number);
            pass_count = pass_count - 1;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Large Seed and Reset Recovery", test_num);
            reset_dut();
            seed = 32'hFFFF_FFFF;

            repeat(1000) @(posedge clk);


            if (random_number != 32'h0 && random_number != 32'hFFFF_FFFF) begin
                $display("Status: Data valid.");
                #1;

                check_outputs(random_number);
            end else begin
                $display("Status: FAIL - Potential saturation or logic error.");
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
        $dumpvars(0,clk, reset, seed, random_number);
    end

endmodule
