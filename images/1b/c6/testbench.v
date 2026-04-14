`timescale 1ns/1ps

module chacha20_simple_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] key;
    reg reset;
    wire [31:0] output_stream;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chacha20_simple dut (
        .clk(clk),
        .key(key),
        .reset(reset),
        .output_stream(output_stream)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            key = 32'h0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: All Zeros Key", test_num);
            reset_dut();
            key = 32'h00000000;


            repeat(20) @(posedge clk);


            #1;



            check_outputs(32'h2C218B11);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: All Ones Key", test_num);
            reset_dut();
            key = 32'hFFFFFFFF;

            repeat(20) @(posedge clk);

            #1;


            check_outputs(32'h7D8F5C3E);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Checkerboard Pattern 1", test_num);
            reset_dut();
            key = 32'h55555555;

            repeat(20) @(posedge clk);

            #1;


            check_outputs(32'h9A4B120F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Checkerboard Pattern 2", test_num);
            reset_dut();
            key = 32'hAAAAAAAA;

            repeat(20) @(posedge clk);

            #1;


            check_outputs(32'hE5D2A1B0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Test Case %0d: Incremental Pattern", test_num);
            reset_dut();
            key = 32'h12345678;

            repeat(20) @(posedge clk);

            #1;


            check_outputs(32'hB466D12C);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("chacha20_simple Testbench");
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
        $dumpvars(0,clk, key, reset, output_stream);
    end

endmodule
