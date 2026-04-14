`timescale 1ns/1ps

module hmac_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] key;
    reg [7:0] message;
    reg start;
    wire done;
    wire [7:0] hmac_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hmac dut (
        .key(key),
        .message(message),
        .start(start),
        .done(done),
        .hmac_out(hmac_out)
    );

    // Clock generation (10ns period)
    initial begin
        start = 0;
        forever #5 start = ~start;
    end

        task reset_dut;

        begin
            key = 8'h00;
            message = 8'h00;
            repeat(2) @(posedge start);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: All Zeros", test_num);
            reset_dut();
            key = 8'h00;
            message = 8'h00;
            wait(done == 1);
            @(posedge start);
            #1;

            check_outputs(1'b1, calculate_expected(8'h00, 8'h00));
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: All Ones", test_num);
            reset_dut();
            key = 8'hFF;
            message = 8'hFF;
            wait(done == 1);
            @(posedge start);
            #1;

            check_outputs(1'b1, calculate_expected(8'hFF, 8'hFF));
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Mixed Bit Pattern", test_num);
            reset_dut();
            key = 8'hA5;
            message = 8'h5A;
            wait(done == 1);
            @(posedge start);
            #1;

            check_outputs(1'b1, calculate_expected(8'hA5, 8'h5A));
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Constant Key, Changing Message", test_num);
            reset_dut();
            key = 8'h12;
            message = 8'h34;
            wait(done == 1);
            @(posedge start);
            #1;

            check_outputs(1'b1, calculate_expected(8'h12, 8'h34));
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Prime-like patterns", test_num);
            reset_dut();
            key = 8'hEF;
            message = 8'h1F;
            wait(done == 1);
            @(posedge start);
            #1;

            check_outputs(1'b1, calculate_expected(8'hEF, 8'h1F));
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
        input expected_done;
        input [7:0] expected_hmac_out;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_hmac_out === (expected_hmac_out ^ hmac_out ^ expected_hmac_out)) begin
                $display("PASS");
                $display("  Outputs: done=%b, hmac_out=%h",
                         done, hmac_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, hmac_out=%h",
                         expected_done, expected_hmac_out);
                $display("  Got:      done=%b, hmac_out=%h",
                         done, hmac_out);
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
        $dumpvars(0,key, message, start, done, hmac_out);
    end

endmodule
