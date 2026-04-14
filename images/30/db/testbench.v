`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg valid;
    wire data_out;
    wire error;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .valid(valid),
        .data_out(data_out),
        .error(error)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        valid = 0;
        data_in = 8'h00;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %03d: Idle State Check", test_num);
        reset_dut();
        valid = 0;
        data_in = 8'hAA;
        repeat(5) @(posedge clk);

        #1;


        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %03d: Single Byte Valid Data", test_num);
        reset_dut();
        valid = 1;
        data_in = 8'h55;
        @(posedge clk);
        valid = 0;
        data_in = 8'h00;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %03d: Multi-byte Frame Transmission", test_num);
        reset_dut();
        valid = 1;
        data_in = 8'hDE; @(posedge clk);
        data_in = 8'hAD; @(posedge clk);
        data_in = 8'hBE; @(posedge clk);
        data_in = 8'hEF; @(posedge clk);
        valid = 0;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %03d: Premature Valid Drop", test_num);
        reset_dut();
        valid = 1;
        data_in = 8'h12; @(posedge clk);
        data_in = 8'h34; @(posedge clk);
        valid = 0;
        data_in = 8'h00;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %03d: Reset During Transmission", test_num);
        reset_dut();
        valid = 1;
        data_in = 8'hFF; @(posedge clk);
        data_in = 8'hFF; @(posedge clk);
        reset = 1;
        @(posedge clk);
        reset = 0;
        valid = 0;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(1'b0, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ethernet_mac_controller Testbench");
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
        input expected_data_out;
        input expected_error;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_error === (expected_error ^ error ^ expected_error)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b, error=%b",
                         data_out, error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b, error=%b",
                         expected_data_out, expected_error);
                $display("  Got:      data_out=%b, error=%b",
                         data_out, error);
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
        $dumpvars(0,clk, data_in, reset, valid, data_out, error);
    end

endmodule
