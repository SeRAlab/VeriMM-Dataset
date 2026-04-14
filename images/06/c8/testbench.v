`timescale 1ns/1ps

module spi_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg cs;
    reg [7:0] data_in;
    reg reset;
    wire [7:0] data_out;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_controller dut (
        .clk(clk),
        .cs(cs),
        .data_in(data_in),
        .reset(reset),
        .data_out(data_out),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            cs = 1;
            data_in = 8'h0;
            repeat(2) @(posedge clk);
            reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = test_num + 1;
            pattern = 8'hAA;
            $display("Test Case %0d: Shifting in pattern 0x%h", test_num, pattern);
            reset_dut();

            @(negedge clk);
            cs = 0;
            for (i = 7; i >= 0; i = i - 1) begin
                data_in = {7'b0, pattern[i]};
                @(posedge clk);
            end

            @(negedge clk);
            cs = 1;
            @(posedge clk);

            #1;


            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = test_num + 1;
            pattern = 8'h55;
            $display("Test Case %0d: Shifting in pattern 0x%h", test_num, pattern);
            reset_dut();

            @(negedge clk);
            cs = 0;
            for (i = 7; i >= 0; i = i - 1) begin
                data_in = {7'b0, pattern[i]};
                @(posedge clk);
            end

            @(negedge clk);
            cs = 1;
            @(posedge clk);

            #1;


            check_outputs(8'h55, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = test_num + 1;
            pattern = 8'hFF;
            $display("Test Case %0d: Shifting in pattern 0x%h", test_num, pattern);
            reset_dut();

            @(negedge clk);
            cs = 0;
            for (i = 7; i >= 0; i = i - 1) begin
                data_in = {7'b0, pattern[i]};
                @(posedge clk);
            end

            @(negedge clk);
            cs = 1;
            @(posedge clk);

            #1;


            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = test_num + 1;
            pattern = 8'h00;
            $display("Test Case %0d: Shifting in pattern 0x%h", test_num, pattern);
            reset_dut();


            @(negedge clk);
            cs = 0;
            data_in = 8'h1;
            repeat(8) @(posedge clk);
            cs = 1;
            @(posedge clk);


            @(negedge clk);
            cs = 0;
            for (i = 7; i >= 0; i = i - 1) begin
                data_in = {7'b0, pattern[i]};
                @(posedge clk);
            end

            @(negedge clk);
            cs = 1;
            @(posedge clk);

            #1;


            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = test_num + 1;
            pattern = 8'h3C;
            $display("Test Case %0d: Verification of Ready signal during shift", test_num);
            reset_dut();

            @(negedge clk);
            cs = 0;
            for (i = 7; i >= 4; i = i - 1) begin
                data_in = {7'b0, pattern[i]};
                @(posedge clk);
            end


            if (ready === 1'b0) begin
                $display("  Internal Check: Ready is correctly 0 during shift.");
            end else begin
                $display("  Internal Check: FAIL - Ready should be 0 during shift.");
            end

            for (i = 3; i >= 0; i = i - 1) begin
                data_in = {7'b0, pattern[i]};
                @(posedge clk);
            end

            @(negedge clk);
            cs = 1;
            @(posedge clk);

            #1;


            check_outputs(8'h3C, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("spi_controller Testbench");
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
        input [7:0] expected_data_out;
        input expected_ready;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, ready=%b",
                         data_out, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, ready=%b",
                         expected_data_out, expected_ready);
                $display("  Got:      data_out=%h, ready=%b",
                         data_out, ready);
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
        $dumpvars(0,clk, cs, data_in, reset, data_out, ready);
    end

endmodule
