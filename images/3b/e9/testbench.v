`timescale 1ns/1ps

module sha256_simple_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] message;
    reg rst;
    wire [255:0] hash;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sha256_simple dut (
        .clk(clk),
        .message(message),
        .rst(rst),
        .hash(hash)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            message = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            reset_dut();
            message = 256'h0;


            repeat(100) @(posedge clk);

            #1;


            check_outputs(256'h0ba904eba2346087d3d0f04e76d97c36d078b66e311a2f664a3952f1e605d82c);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones", test_num);
            reset_dut();
            message = {256{1'b1}};

            repeat(100) @(posedge clk);

            #1;


            check_outputs(256'hf99e319985223075c3d258eb2ef75e4785ca5583b4847e766da1001e747352b2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Pattern 0123...DEF", test_num);
            reset_dut();
            message = 256'h0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef;

            repeat(100) @(posedge clk);

            #1;


            check_outputs(256'h6936d933e4b7880775c742c3664d1f56556f8f55331f24d10f4435987a07c427);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bits (555...)", test_num);
            reset_dut();
            message = {64{4'h5}};

            repeat(100) @(posedge clk);

            #1;


            check_outputs(256'h60959d95447477157a943a416a9a014902a28178d8f993f4129528659d646b57);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sha256_simple Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [255:0] expected_hash;
        begin
            if (expected_hash === (expected_hash ^ hash ^ expected_hash)) begin
                $display("PASS");
                $display("  Outputs: hash=%h",
                         hash);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash=%h",
                         expected_hash);
                $display("  Got:      hash=%h",
                         hash);
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
        $dumpvars(0,clk, message, rst, hash);
    end

endmodule
