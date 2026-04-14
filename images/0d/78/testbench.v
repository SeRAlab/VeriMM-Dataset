`timescale 1ns/1ps

module SimpleHMAC_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] key;
    reg [7:0] message;
    reg rst;
    reg start;
    wire [7:0] hash;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SimpleHMAC dut (
        .clk(clk),
        .key(key),
        .message(message),
        .rst(rst),
        .start(start),
        .hash(hash),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            key = 8'h0;
            message = 8'h0;
            repeat (2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: All Zeros", test_num);
            reset_dut();
            key = 8'h00;
            message = 8'h00;
            start = 1;
            @(posedge clk);
            start = 0;


            while (!valid) @(posedge clk);


            #1;



            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: All-Ones Key, Zero Message", test_num);
            reset_dut();
            key = 8'hFF;
            message = 8'h00;
            start = 1;
            @(posedge clk);
            start = 0;

            while (!valid) @(posedge clk);


            #1;



            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Zero Key, All-Ones Message", test_num);
            reset_dut();
            key = 8'h00;
            message = 8'hFF;
            start = 1;
            @(posedge clk);
            start = 0;

            while (!valid) @(posedge clk);


            #1;



            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Alternating Bit Patterns", test_num);
            reset_dut();
            key = 8'hAA;
            message = 8'h55;
            start = 1;
            @(posedge clk);
            start = 0;

            while (!valid) @(posedge clk);


            #1;



            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Arbitrary Hex Values", test_num);
            reset_dut();
            key = 8'h12;
            message = 8'h34;
            start = 1;
            @(posedge clk);
            start = 0;

            while (!valid) @(posedge clk);


            #1;



            check_outputs(8'h26, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Identical Key and Message", test_num);
            reset_dut();
            key = 8'hBD;
            message = 8'hBD;
            start = 1;
            @(posedge clk);
            start = 0;

            while (!valid) @(posedge clk);


            #1;



            check_outputs(8'h00, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SimpleHMAC Testbench");
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
        input [7:0] expected_hash;
        input expected_valid;
        begin
            if (expected_hash === (expected_hash ^ hash ^ expected_hash) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: hash=%h, valid=%b",
                         hash, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash=%h, valid=%b",
                         expected_hash, expected_valid);
                $display("  Got:      hash=%h, valid=%b",
                         hash, valid);
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
        $dumpvars(0,clk, key, message, rst, start, hash, valid);
    end

endmodule
