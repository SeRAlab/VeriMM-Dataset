`timescale 1ns/1ps

module fft_32_point_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1023:0] data_in;
    reg reset;
    wire [1023:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fft_32_point dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 0;
            repeat(5) @(posedge clk);
            reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        reg [1023:0] expected;
        integer i;
        begin
            test_num = 1;
            $display("Testcase %03d: Unit Impulse x[0]=1", test_num);
            reset_dut();


            data_in = 0;
            data_in[31:16] = 16'h0001;
            data_in[15:0]  = 16'h0000;


            repeat(100) @(posedge clk);


            for (i = 0; i < 32; i = i + 1) begin
                expected[i*32 + 31 : i*32 + 16] = 16'h0001;
                expected[i*32 + 15 : i*32 + 0]  = 16'h0000;
            end

            #1;


            check_outputs(expected);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: All Zeros", test_num);
            reset_dut();

            data_in = 0;
            repeat(100) @(posedge clk);

            #1;


            check_outputs(0);
        end
        endtask

    task testcase003;

        reg [1023:0] expected;
        integer i;
        begin
            test_num = 3;
            $display("Testcase %03d: DC Signal (All ones)", test_num);
            reset_dut();


            for (i = 0; i < 32; i = i + 1) begin
                data_in[i*32 + 31 : i*32 + 16] = 16'h0001;
                data_in[i*32 + 15 : i*32 + 0]  = 16'h0000;
            end

            repeat(100) @(posedge clk);


            expected = 0;
            expected[31:16] = 16'd32;
            expected[15:0]  = 16'h0000;

            #1;


            check_outputs(expected);
        end
        endtask

    task testcase004;

        reg [1023:0] expected;
        integer i;
        begin
            test_num = 4;
            $display("Testcase %03d: Pure Imaginary Impulse x[0]=j", test_num);
            reset_dut();

            data_in = 0;
            data_in[31:16] = 16'h0000;
            data_in[15:0]  = 16'h0001;

            repeat(100) @(posedge clk);

            for (i = 0; i < 32; i = i + 1) begin
                expected[i*32 + 31 : i*32 + 16] = 16'h0000;
                expected[i*32 + 15 : i*32 + 0]  = 16'h0001;
            end

            #1;


            check_outputs(expected);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fft_32_point Testbench");
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
        input [1023:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, reset, data_out);
    end

endmodule
