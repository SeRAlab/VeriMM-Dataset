`timescale 1ns/1ps

module hmac_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] key;
    reg [31:0] message;
    reg reset;
    reg start;
    wire [31:0] hmac_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hmac dut (
        .clk(clk),
        .key(key),
        .message(message),
        .reset(reset),
        .start(start),
        .hmac_out(hmac_out),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            key = 0;
            message = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: All Zeros", test_num);
            reset_dut();
            key = 32'h00000000;
            message = 32'h00000000;
            start = 1;
            @(posedge clk);
            start = 0;


            while (!valid) @(posedge clk);


            #1;



            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Key with Zero Message", test_num);
            reset_dut();
            key = 32'hA5A5A5A5;
            message = 32'h00000000;
            start = 1;
            @(posedge clk);
            start = 0;

            while (!valid) @(posedge clk);


            #1;



            check_outputs(32'hA5A5A5A5, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Zero Key with Message", test_num);
            reset_dut();
            key = 32'h00000000;
            message = 32'h12345678;
            start = 1;
            @(posedge clk);
            start = 0;

            while (!valid) @(posedge clk);


            #1;



            check_outputs(32'h12345678, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Arbitrary Data", test_num);
            reset_dut();
            key = 32'hFEDCBA98;
            message = 32'h76543210;
            start = 1;
            @(posedge clk);
            start = 0;

            while (!valid) @(posedge clk);


            #1;



            check_outputs(32'hFEDCBA98 ^ 32'h76543210, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: All Ones", test_num);
            reset_dut();
            key = 32'hFFFFFFFF;
            message = 32'hFFFFFFFF;
            start = 1;
            @(posedge clk);
            start = 0;

            while (!valid) @(posedge clk);


            #1;



            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hmac Testbench");
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
        input [31:0] expected_hmac_out;
        input expected_valid;
        begin
            if (expected_hmac_out === (expected_hmac_out ^ hmac_out ^ expected_hmac_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: hmac_out=%h, valid=%b",
                         hmac_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hmac_out=%h, valid=%b",
                         expected_hmac_out, expected_valid);
                $display("  Got:      hmac_out=%h, valid=%b",
                         hmac_out, valid);
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
        $dumpvars(0,clk, key, message, reset, start, hmac_out, valid);
    end

endmodule
