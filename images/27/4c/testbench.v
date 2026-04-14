`timescale 1ns/1ps

module rle_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    wire [15:0] data_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rle_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .data_out(data_out),
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
            data_in = 8'h0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic run of 2 identical bytes", test_num);
            reset_dut();

            data_in = 8'hAA; @(posedge clk); #1;
            data_in = 8'hAA; @(posedge clk); #1;
            data_in = 8'hBB; @(posedge clk); #1;

            #1;


            check_outputs(16'hAA02, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single byte run", test_num);
            reset_dut();

            data_in = 8'h11; @(posedge clk); #1;
            data_in = 8'h22; @(posedge clk); #1;

            #1;


            check_outputs(16'h1101, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Run of 10 bytes", test_num);
            reset_dut();

            for (i = 0; i < 10; i = i + 1) begin
                data_in = 8'h55;
                @(posedge clk);
                #1;
            end
            data_in = 8'h00; @(posedge clk); #1;

            #1;


            check_outputs(16'h550A, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum count (255)", test_num);
            reset_dut();

            for (i = 0; i < 255; i = i + 1) begin
                data_in = 8'hEE;
                @(posedge clk);
                #1;
            end
            data_in = 8'hFF; @(posedge clk); #1;

            #1;


            check_outputs(16'hEEFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 0xFF data check", test_num);
            reset_dut();

            data_in = 8'hFF; @(posedge clk); #1;
            data_in = 8'hFF; @(posedge clk); #1;
            data_in = 8'hFF; @(posedge clk); #1;
            data_in = 8'h00; @(posedge clk); #1;

            #1;


            check_outputs(16'hFF03, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rle_encoder Testbench");
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
        input [15:0] expected_data_out;
        input expected_valid;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, valid=%b",
                         data_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, valid=%b",
                         expected_data_out, expected_valid);
                $display("  Got:      data_out=%h, valid=%b",
                         data_out, valid);
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
        $dumpvars(0,clk, data_in, rst, data_out, valid);
    end

endmodule
