`timescale 1ns/1ps

module DES_tb;

    // Testbench signals (sequential circuit)
    reg [63:0] input_block;
    reg [55:0] key;
    reg start;
    wire done;
    wire [63:0] output_block;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DES dut (
        .input_block(input_block),
        .key(key),
        .start(start),
        .done(done),
        .output_block(output_block)
    );

    // Clock generation (10ns period)
    initial begin
        start = 0;
        forever #5 start = ~start;
    end

        task reset_dut;

    begin


        input_block = 64'h0;
        key = 56'h0;
        repeat(2) @(posedge start);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: All Zeros", test_num);
        reset_dut();

        @(negedge start);
        input_block = 64'h0000000000000000;
        key         = 56'h00000000000000;


        wait(done === 1'b1);
        #1;

        check_outputs(1'b1, 64'h8CA64DE9C1B123A7);
        repeat(2) @(posedge start);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Standard NIST Vector", test_num);
        reset_dut();

        @(negedge start);
        input_block = 64'h0123456789ABCDEF;
        key         = 56'h133457799BBCDF;

        wait(done === 1'b1);
        #1;

        check_outputs(1'b1, 64'h3FA40E8A984D4815);
        repeat(2) @(posedge start);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: All Ones", test_num);
        reset_dut();

        @(negedge start);
        input_block = 64'hFFFFFFFFFFFFFFFF;
        key         = 56'hFFFFFFFFFFFFFF;

        wait(done === 1'b1);
        #1;

        check_outputs(1'b1, 64'h7359B2163E4EDC58);
        repeat(2) @(posedge start);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Alternating Patterns", test_num);
        reset_dut();

        @(negedge start);
        input_block = 64'h5555555555555555;
        key         = 56'h2AAAAAAAAAAAAA;

        wait(done === 1'b1);

        #1;


        check_outputs(1'b1, 64'hCBAB80E3992290FA);
        repeat(2) @(posedge start);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DES Testbench");
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
        input expected_done;
        input [63:0] expected_output_block;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_output_block === (expected_output_block ^ output_block ^ expected_output_block)) begin
                $display("PASS");
                $display("  Outputs: done=%b, output_block=%h",
                         done, output_block);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, output_block=%h",
                         expected_done, expected_output_block);
                $display("  Got:      done=%b, output_block=%h",
                         done, output_block);
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
        $dumpvars(0,input_block, key, start, done, output_block);
    end

endmodule
