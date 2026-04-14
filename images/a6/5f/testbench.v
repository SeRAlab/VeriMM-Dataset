`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] address;
    reg clk;
    reg cs;
    reg debug_update;
    reg discard;
    reg entropy_ack;
    reg reset_n;
    reg test_mode;
    reg we;
    reg [31:0] write_data;
    wire [7:0] debug;
    wire [31:0] entropy_data;
    wire entropy_enabled;
    wire entropy_valid;
    wire error;
    wire [31:0] read_data;
    wire security_error;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clk(clk),
        .cs(cs),
        .debug_update(debug_update),
        .discard(discard),
        .entropy_ack(entropy_ack),
        .reset_n(reset_n),
        .test_mode(test_mode),
        .we(we),
        .write_data(write_data),
        .debug(debug),
        .entropy_data(entropy_data),
        .entropy_enabled(entropy_enabled),
        .entropy_valid(entropy_valid),
        .error(error),
        .read_data(read_data),
        .security_error(security_error)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: System Reset and Initial State", test_num);


        reset_n = 0;
        cs = 0;
        we = 0;
        address = 8'h0;
        write_data = 32'h0;
        discard = 0;
        test_mode = 0;
        entropy_ack = 0;
        debug_update = 0;

        repeat(5) @(posedge clk);
        reset_n = 1;
        repeat(5) @(posedge clk);



        #1;




        check_outputs(
            8'h0,
            32'h0,
            1'b1,
            1'b1,
            1'b0,
            32'h0,
            1'b0
        );
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Fixed Read Value Check", test_num);


        reset_n = 0; #20; reset_n = 1; #20;


        @(posedge clk);
        cs = 1;
        we = 0;
        address = 8'hA5;

        repeat(2) @(posedge clk);

        #1;


        check_outputs(8'h0, 32'h0, 1'b1, 1'b1, 1'b0, 32'h0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Write Operation Robustness", test_num);


        reset_n = 0; #20; reset_n = 1; #20;


        @(posedge clk);
        cs = 1;
        we = 1;
        address = 8'h20;
        write_data = 32'hDEADBEEF;

        repeat(2) @(posedge clk);

        #1;


        check_outputs(8'h0, 32'h0, 1'b1, 1'b1, 1'b0, 32'h0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Entropy Acknowledgement Flow", test_num);


        reset_n = 0; #20; reset_n = 1; #20;


        @(posedge clk);
        entropy_ack = 1;
        discard = 1;

        repeat(5) @(posedge clk);


        #1;



        check_outputs(8'h0, 32'h0, 1'b1, 1'b1, 1'b0, 32'h0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Test Mode and Debug Diagnostics", test_num);


        reset_n = 0; #20; reset_n = 1; #20;


        @(posedge clk);
        test_mode = 1;
        debug_update = 1;

        repeat(2) @(posedge clk);
        debug_update = 0;
        repeat(2) @(posedge clk);


        #1;



        check_outputs(8'h0, 32'h0, 1'b1, 1'b1, 1'b0, 32'h0, 1'b0);
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
        input [7:0] expected_debug;
        input [31:0] expected_entropy_data;
        input expected_entropy_enabled;
        input expected_entropy_valid;
        input expected_error;
        input [31:0] expected_read_data;
        input expected_security_error;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_debug === (expected_debug ^ debug ^ expected_debug) &&
                expected_entropy_data === (expected_entropy_data ^ entropy_data ^ expected_entropy_data) &&
                expected_entropy_enabled === (expected_entropy_enabled ^ entropy_enabled ^ expected_entropy_enabled) &&
                expected_entropy_valid === (expected_entropy_valid ^ entropy_valid ^ expected_entropy_valid) &&
                expected_error === (expected_error ^ error ^ expected_error) &&
                expected_read_data === (expected_read_data ^ read_data ^ expected_read_data) &&
                expected_security_error === (expected_security_error ^ security_error ^ expected_security_error)) begin
                $display("PASS");
                $display("  Outputs: debug=%h, entropy_data=%h, entropy_enabled=%b, entropy_valid=%b, error=%b, read_data=%h, security_error=%b",
                         debug, entropy_data, entropy_enabled, entropy_valid, error, read_data, security_error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: debug=%h, entropy_data=%h, entropy_enabled=%b, entropy_valid=%b, error=%b, read_data=%h, security_error=%b",
                         expected_debug, expected_entropy_data, expected_entropy_enabled, expected_entropy_valid, expected_error, expected_read_data, expected_security_error);
                $display("  Got:      debug=%h, entropy_data=%h, entropy_enabled=%b, entropy_valid=%b, error=%b, read_data=%h, security_error=%b",
                         debug, entropy_data, entropy_enabled, entropy_valid, error, read_data, security_error);
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
