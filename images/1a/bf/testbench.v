`timescale 1ns/1ps

module chacha20_simple_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] key;
    reg reset;
    wire [31:0] stream;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chacha20_simple dut (
        .clk(clk),
        .key(key),
        .reset(reset),
        .stream(stream)
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
            $display("\nRunning Testcase %0d: Key=0, Initial Cycle", test_num);
            reset_dut();
            key = 32'h0000_0000;


            @(posedge clk);
            #1;



            #1;




            check_outputs(32'h61707864);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Key=0x12345678, Initial Cycle", test_num);
            reset_dut();
            key = 32'h1234_5678;

            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h73442E1C);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Key=0, After 5 Clock Cycles", test_num);
            reset_dut();
            key = 32'h0000_0000;


            repeat(5) @(posedge clk);
            #1;


            #1;



            check_outputs(32'h61707860);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Key=0xFFFFFFFF", test_num);
            reset_dut();
            key = 32'hFFFF_FFFF;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h9E8F879B);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Reset Consistency Check", test_num);


            reset_dut();
            key = 32'hA5A5_B6B6;
            @(posedge clk);
            #1;


            reset_dut();
            key = 32'hA5A5_B6B6;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'hC4D5A1B2);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Long duration (100 cycles)", test_num);
            reset_dut();
            key = 32'hDEAD_BEEF;

            repeat(100) @(posedge clk);
            #1;

            #1;


            check_outputs(32'h1A2B3C4D);
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
        testcase006();
        
        
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
        input [31:0] expected_stream;
        begin
            if (expected_stream === (expected_stream ^ stream ^ expected_stream)) begin
                $display("PASS");
                $display("  Outputs: stream=%h",
                         stream);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: stream=%h",
                         expected_stream);
                $display("  Got:      stream=%h",
                         stream);
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
        $dumpvars(0,clk, key, reset, stream);
    end

endmodule
