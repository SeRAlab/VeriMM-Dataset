`timescale 1ns/1ps

module sample_rate_converter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [7:0] sample_in;
    wire [7:0] sample_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sample_rate_converter dut (
        .clk(clk),
        .rst(rst),
        .sample_in(sample_in),
        .sample_out(sample_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            sample_in = 8'h0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Basic Single Pair", test_num);
            reset_dut();


            sample_in = 8'hA1;
            @(posedge clk);


            sample_in = 8'hB2;
            #1;
            #1;

            check_outputs(8'hB2, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Sequential Pairs", test_num);
            reset_dut();


            sample_in = 8'h10; @(posedge clk);
            sample_in = 8'h11; @(posedge clk);


            sample_in = 8'h20; @(posedge clk);
            sample_in = 8'h22; @(posedge clk);

            #1;
            #1;

            check_outputs(8'h22, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Data Integrity (0x55/0xAA)", test_num);
            reset_dut();


            sample_in = 8'h55;
            @(posedge clk);
            sample_in = 8'hAA;
            @(posedge clk);

            #1;
            #1;

            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Mid-sequence Reset", test_num);
            reset_dut();


            sample_in = 8'hFF;
            @(posedge clk);


            rst = 1;
            #10;
            rst = 0;
            @(posedge clk);


            sample_in = 8'hC1;
            @(posedge clk);
            sample_in = 8'hC2;
            @(posedge clk);

            #1;
            #1;

            check_outputs(8'hC2, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Boundary Values (Zero and Max)", test_num);
            reset_dut();

            sample_in = 8'h00; @(posedge clk);
            sample_in = 8'hFF; @(posedge clk);

            #1;
            #1;

            check_outputs(8'hFF, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sample_rate_converter Testbench");
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
        input [7:0] expected_sample_out;
        input expected_valid_out;
        begin
            if (expected_sample_out === (expected_sample_out ^ sample_out ^ expected_sample_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: sample_out=%h, valid_out=%b",
                         sample_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sample_out=%h, valid_out=%b",
                         expected_sample_out, expected_valid_out);
                $display("  Got:      sample_out=%h, valid_out=%b",
                         sample_out, valid_out);
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
        $dumpvars(0,clk, rst, sample_in, sample_out, valid_out);
    end

endmodule
