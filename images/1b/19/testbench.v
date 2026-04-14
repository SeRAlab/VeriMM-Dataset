`timescale 1ns/1ps

module serializer_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [31:0] parallel_in;
    reg reset;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    serializer_32bit dut (
        .clk(clk),
        .enable(enable),
        .parallel_in(parallel_in),
        .reset(reset),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            parallel_in = 32'h0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case %0d: MSB Shift Out (Start)", test_num);
            parallel_in = 32'h8000_0000;
            enable = 1;
            @(posedge clk);
            enable = 0;
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case %0d: LSB Shift Out (End of 32 cycles)", test_num);
            parallel_in = 32'h0000_0001;
            enable = 1;
            @(posedge clk);
            enable = 0;
            repeat(31) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case %0d: Middle Bit (Bit 15)", test_num);
            parallel_in = 32'h0000_8000;
            enable = 1;
            @(posedge clk);
            enable = 0;
            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case %0d: Hold Final Bit", test_num);
            parallel_in = 32'hFFFF_FFFF;
            enable = 1;
            @(posedge clk);
            enable = 0;
            repeat(40) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case %0d: All Zeros Pattern", test_num);
            parallel_in = 32'h0000_0000;
            enable = 1;
            @(posedge clk);
            enable = 0;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test Case %0d: Alternating Pattern 0xAAAA_AAAA (Check bit 30)", test_num);
            parallel_in = 32'hAAAA_AAAA;
            enable = 1;
            @(posedge clk);
            enable = 0;
            repeat(1) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Test Case %0d: New Start sequence after first one finishes", test_num);

            parallel_in = 32'h0;
            enable = 1;
            @(posedge clk);
            enable = 0;
            repeat(32) @(posedge clk);


            parallel_in = 32'h8000_0000;
            enable = 1;
            @(posedge clk);
            enable = 0;
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Test Case %0d: Reset Mid-Operation", test_num);
            parallel_in = 32'hFFFF_FFFF;
            enable = 1;
            @(posedge clk);
            enable = 0;
            repeat(5) @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("serializer_32bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_serial_out;
        begin
            if (expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: serial_out=%b",
                         serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: serial_out=%b",
                         expected_serial_out);
                $display("  Got:      serial_out=%b",
                         serial_out);
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
        $dumpvars(0,clk, enable, parallel_in, reset, serial_out);
    end

endmodule
