`timescale 1ns/1ps

module csprng_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [7:0] seed;
    wire [7:0] random_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    csprng dut (
        .clk(clk),
        .rst(rst),
        .seed(seed),
        .random_out(random_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        input [7:0] s;
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
            reset_dut(8'h01);

            #1;


            check_outputs(8'h01);
        end
        endtask

    task testcase002;

        begin
            reset_dut(8'hA5);
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            reset_dut(8'h01);
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h8E);
        end
        endtask

    task testcase004;

        begin
            reset_dut(8'h01);
            repeat (2) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h47);
        end
        endtask

    task testcase005;

        begin
            reset_dut(8'hFF);
            repeat (10) @(posedge clk);
            #1;

            if (random_out != 8'hFF && random_out != 8'h00) begin
                $display("Test Case 005: PASS (Sequence active)");
                pass_count = pass_count + 1;
                test_num = test_num + 1;
            end else begin
                $display("Test Case 005: FAIL (Stuck or invalid state)");
                fail_count = fail_count + 1;
                test_num = test_num + 1;
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
        input [7:0] expected_random_out;
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
        $dumpvars(0,clk, rst, seed, random_out);
    end

endmodule
