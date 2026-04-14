`timescale 1ns/1ps

module deserializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg reset;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deserializer dut (
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
            data_in = 16'h0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Basic alternating pattern AAAA then 5555", test_num);
            reset_dut();
            @(negedge clk);
            data_in = 16'hAAAA;
            @(negedge clk);
            data_in = 16'h5555;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hAAAA5555);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: All ones then all zeros", test_num);
            reset_dut();
            @(negedge clk);
            data_in = 16'hFFFF;
            @(negedge clk);
            data_in = 16'h0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFF0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Sequential hex sequence 1234 then 5678", test_num);
            reset_dut();
            @(negedge clk);
            data_in = 16'h1234;
            @(negedge clk);
            data_in = 16'h5678;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Reset functionality check", test_num);
            reset_dut();

            @(negedge clk);
            data_in = 16'hDEAD;
            @(negedge clk);
            data_in = 16'hBEEF;
            @(posedge clk);
            #1;

            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Boundary values FFFF then FFFF", test_num);
            reset_dut();
            @(negedge clk);
            data_in = 16'hFFFF;
            @(negedge clk);
            data_in = 16'hFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deserializer Testbench");
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
        input [31:0] expected_data_out;
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
