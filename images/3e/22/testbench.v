`timescale 1ns/1ps

module chacha20_core_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] key;
    reg rst;
    wire [31:0] output_stream;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chacha20_core dut (
        .clk(clk),
        .key(key),
        .rst(rst),
        .output_stream(output_stream)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        @(posedge clk);
        #1;
        rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        key = 32'hACE12345;
        reset_dut();
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'hACE12345);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        key = 32'h00000001;
        reset_dut();
        @(posedge clk);
        @(posedge clk);
        #1;



        #1;




        check_outputs(32'h00000002);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        key = 32'hF0F0F0F0;
        reset_dut();
        repeat(5) @(posedge clk);
        #1;



        #1;




        check_outputs(32'h1E1E1E00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        key = 32'h00000000;
        reset_dut();
        repeat(10) @(posedge clk);
        #1;

        #1;


        check_outputs(32'h00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        key = 32'h80000000;
        reset_dut();
        @(posedge clk);
        @(posedge clk);
        #1;


        #1;



        check_outputs(32'h04C11DB7);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("chacha20_core Testbench");
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
        input [31:0] expected_output_stream;
        begin
            if (expected_output_stream === (expected_output_stream ^ output_stream ^ expected_output_stream)) begin
                $display("PASS");
                $display("  Outputs: output_stream=%h",
                         output_stream);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_stream=%h",
                         expected_output_stream);
                $display("  Got:      output_stream=%h",
                         output_stream);
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
        $dumpvars(0,clk, key, rst, output_stream);
    end

endmodule
