`timescale 1ns/1ps

module lfsr_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [31:0] seed;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lfsr_32bit dut (
        .clk(clk),
        .rst(rst),
        .seed(seed),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        input [31:0] s;
        begin
            seed = s;
            rst = 1;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Initial Seed Loading (0xACE1BEEF)", test_num);
            reset_dut(32'hACE1_BEEF);

            #1 #1;
 check_outputs(32'hACE1_BEEF);
        end
        endtask

    task testcase002;

        reg [31:0] first_capture;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Deterministic Sequence Consistency", test_num);


            reset_dut(32'h1234_5678);
            repeat(20) @(posedge clk);
            #1 first_capture = out;


            reset_dut(32'h1234_5678);
            repeat(20) @(posedge clk);


            #1 #1;
 check_outputs(first_capture);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: State Transition Check", test_num);
            reset_dut(32'h5555_AAAA);


            @(posedge clk);
            #1;


            if (out != 32'h5555_AAAA && out != 32'h0) begin
                $display("PASS: State moved from seed to %h", out);
                pass_count = pass_count + 1;
            } else begin
                $display("FAIL: State stuck or collapsed to zero");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Long-run Non-zero Stability", test_num);
            reset_dut(32'h0000_0001);


            repeat(500) @(posedge clk);
            #1;


            if (out != 32'h0) begin
                $display("PASS: LFSR remained non-zero after 500 cycles (%h)", out);
                pass_count = pass_count + 1;
            } else begin
                $display("FAIL: LFSR collapsed to zero state");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mid-operation Reset to New Seed", test_num);

            reset_dut(32'hFFFF_FFFF);
            repeat(10) @(posedge clk);


            reset_dut(32'hD00D_FEED);


            #1 #1;
 check_outputs(32'hD00D_FEED);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lfsr_32bit Testbench");
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
        input [31:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, rst, seed, out);
    end

endmodule
