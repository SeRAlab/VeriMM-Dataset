`timescale 1ns/1ps

module sample_rate_converter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sample_rate_converter dut (
        .clk(clk),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            data_in = 0;
            @(negedge clk);
            #2 rst_n = 1;
            $display("DUT Reset completed.");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Basic 2-cycle Decimation", test_num);
            reset_dut();

            @(negedge clk); data_in = 8'hA1;
            @(negedge clk); data_in = 8'hB2;
            @(posedge clk); #2;

            #1;


            check_outputs(8'hA1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: 4-cycle Sequence", test_num);
            reset_dut();

            @(negedge clk); data_in = 8'h10;
            @(negedge clk); data_in = 8'h20;
            @(negedge clk); data_in = 8'h30;
            @(negedge clk); data_in = 8'h40;
            @(posedge clk); #2;

            #1;


            check_outputs(8'h30);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: 6-cycle Long Sequence", test_num);
            reset_dut();

            @(negedge clk); data_in = 8'h01;
            @(negedge clk); data_in = 8'h02;
            @(negedge clk); data_in = 8'h03;
            @(negedge clk); data_in = 8'h04;
            @(negedge clk); data_in = 8'h05;
            @(negedge clk); data_in = 8'h06;
            @(posedge clk); #2;

            #1;


            check_outputs(8'h05);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Mid-Phase Check", test_num);
            reset_dut();

            @(negedge clk); data_in = 8'hAA;
            @(negedge clk); data_in = 8'hBB;
            @(negedge clk); data_in = 8'hCC;
            @(posedge clk); #2;

            #1;


            check_outputs(8'hCC);
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
        $dumpvars(0,clk, data_in, data_out);
    end

endmodule
