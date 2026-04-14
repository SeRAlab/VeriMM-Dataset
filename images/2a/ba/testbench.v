`timescale 1ns/1ps

module sample_rate_converter_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg clk_out;
    reg [15:0] data_in;
    reg reset;
    wire [15:0] data_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sample_rate_converter dut (
        .clk_in(clk_in),
        .clk_out(clk_out),
        .data_in(data_in),
        .reset(reset),
        .data_out(data_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 16'h0;
            repeat(4) @(posedge clk_in);
            #2 reset = 0;
            repeat(2) @(posedge clk_in);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Single Pair Conversion", test_num);
            reset_dut();

            @(posedge clk_in);
            data_in = 16'hAAAA;
            @(posedge clk_in);
            data_in = 16'h1111;


            repeat(5) @(posedge clk_out);

            #1;


            check_outputs(16'hAAAA, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum Value (0xFFFF)", test_num);
            reset_dut();

            @(posedge clk_in);
            data_in = 16'hFFFF;
            @(posedge clk_in);
            data_in = 16'h0000;

            repeat(5) @(posedge clk_out);

            #1;


            check_outputs(16'hFFFF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Stream Processing", test_num);
            reset_dut();


            @(posedge clk_in) data_in = 16'h1010;
            @(posedge clk_in) data_in = 16'h0;
            @(posedge clk_in) data_in = 16'h2020;
            @(posedge clk_in) data_in = 16'h0;
            @(posedge clk_in) data_in = 16'h3030;
            @(posedge clk_in) data_in = 16'h0;
            @(posedge clk_in) data_in = 16'h4040;
            @(posedge clk_in) data_in = 16'h0;


            repeat(10) @(posedge clk_out);


            #1;



            check_outputs(16'h4040, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Value (0x0000)", test_num);
            reset_dut();

            @(posedge clk_in);
            data_in = 16'h0000;
            @(posedge clk_in);
            data_in = 16'hFFFF;

            repeat(5) @(posedge clk_out);

            #1;


            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset during operation", test_num);
            reset_dut();


            @(posedge clk_in) data_in = 16'hDEAD;
            @(posedge clk_in) data_in = 16'hBEEF;

            reset_dut();

            @(posedge clk_in) data_in = 16'h55AA;
            @(posedge clk_in) data_in = 16'h0000;

            repeat(5) @(posedge clk_out);

            #1;


            check_outputs(16'h55AA, 1'b1);
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
        input [15:0] expected_data_out;
        input expected_valid_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, valid_out=%b",
                         data_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, valid_out=%b",
                         expected_data_out, expected_valid_out);
                $display("  Got:      data_out=%h, valid_out=%b",
                         data_out, valid_out);
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
        $dumpvars(0,clk_in, clk_out, data_in, reset, data_out, valid_out);
    end

endmodule
