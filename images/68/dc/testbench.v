`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] din_data;
    reg din_last;
    reg din_valid;
    reg dout_ready;
    reg headers_ready;
    wire din_ready;
    wire [63:0] dout_data;
    wire dout_last;
    wire dout_valid;
    wire [63:0] headers_data;
    wire headers_last;
    wire headers_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din_data(din_data),
        .din_last(din_last),
        .din_valid(din_valid),
        .dout_ready(dout_ready),
        .headers_ready(headers_ready),
        .din_ready(din_ready),
        .dout_data(dout_data),
        .dout_last(dout_last),
        .dout_valid(dout_valid),
        .headers_data(headers_data),
        .headers_last(headers_last),
        .headers_valid(headers_valid)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Idle State - Initializing inputs", test_num);


            din_data = 64'h0;
            din_last = 1'b0;
            din_valid = 1'b0;
            dout_ready = 1'b1;
            headers_ready = 1'b1;


            #1;



            check_outputs(
                1'b1,
                64'bx,
                1'bx,
                1'bx,
                64'bx,
                1'bx,
                1'bx
            );
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data Input - Valid packet start", test_num);


            din_data = 64'hAABBCCDD_11223344;
            din_last = 1'b0;
            din_valid = 1'b1;
            dout_ready = 1'b1;
            headers_ready = 1'b1;


            #1;



            check_outputs(
                1'b1,
                64'bx,
                1'bx,
                1'bx,
                64'bx,
                1'bx,
                1'bx
            );
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data Input - End of packet", test_num);


            din_data = 64'hFFFFFFFF_00000000;
            din_last = 1'b1;
            din_valid = 1'b1;
            dout_ready = 1'b1;
            headers_ready = 1'b1;


            #1;



            check_outputs(
                1'b1,
                64'bx,
                1'bx,
                1'bx,
                64'bx,
                1'bx,
                1'bx
            );
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Backpressure - Downstream not ready", test_num);


            din_data = 64'h12345678_9ABCDEF0;
            din_last = 1'b0;
            din_valid = 1'b1;
            dout_ready = 1'b0;
            headers_ready = 1'b0;


            #1;



            check_outputs(
                1'b1,
                64'bx,
                1'bx,
                1'bx,
                64'bx,
                1'bx,
                1'bx
            );
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_din_ready;
        input [63:0] expected_dout_data;
        input expected_dout_last;
        input expected_dout_valid;
        input [63:0] expected_headers_data;
        input expected_headers_last;
        input expected_headers_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_din_ready === (expected_din_ready ^ din_ready ^ expected_din_ready) &&
                expected_dout_data === (expected_dout_data ^ dout_data ^ expected_dout_data) &&
                expected_dout_last === (expected_dout_last ^ dout_last ^ expected_dout_last) &&
                expected_dout_valid === (expected_dout_valid ^ dout_valid ^ expected_dout_valid) &&
                expected_headers_data === (expected_headers_data ^ headers_data ^ expected_headers_data) &&
                expected_headers_last === (expected_headers_last ^ headers_last ^ expected_headers_last) &&
                expected_headers_valid === (expected_headers_valid ^ headers_valid ^ expected_headers_valid)) begin
                $display("PASS");
                $display("  Outputs: din_ready=%b, dout_data=%h, dout_last=%b, dout_valid=%b, headers_data=%h, headers_last=%b, headers_valid=%b",
                         din_ready, dout_data, dout_last, dout_valid, headers_data, headers_last, headers_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: din_ready=%b, dout_data=%h, dout_last=%b, dout_valid=%b, headers_data=%h, headers_last=%b, headers_valid=%b",
                         expected_din_ready, expected_dout_data, expected_dout_last, expected_dout_valid, expected_headers_data, expected_headers_last, expected_headers_valid);
                $display("  Got:      din_ready=%b, dout_data=%h, dout_last=%b, dout_valid=%b, headers_data=%h, headers_last=%b, headers_valid=%b",
                         din_ready, dout_data, dout_last, dout_valid, headers_data, headers_last, headers_valid);
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

endmodule
