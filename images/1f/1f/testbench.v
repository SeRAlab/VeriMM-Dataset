`timescale 1ns/1ps

module sample_rate_converter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sample_rate_converter dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 8'h00;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            data_in = 8'h10;
            @(posedge clk); #1;

            data_in = 8'h20;
            @(posedge clk); #1;
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            data_in = 8'hA1; @(posedge clk); #1;
            data_in = 8'hB2; @(posedge clk); #1;
            data_in = 8'hC3; @(posedge clk); #1;
            data_in = 8'hD4; @(posedge clk); #1;

            #1;


            check_outputs(8'hC3);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            data_in = 8'hFF; @(posedge clk); #1;
            data_in = 8'h00; @(posedge clk); #1;
            data_in = 8'hFF; @(posedge clk); #1;
            data_in = 8'h55; @(posedge clk); #1;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            data_in = 8'h00; @(posedge clk); #1;
            data_in = 8'hFF; @(posedge clk); #1;
            data_in = 8'h00; @(posedge clk); #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            data_in = 8'h01; @(posedge clk); #1;
            data_in = 8'h02; @(posedge clk); #1;
            data_in = 8'h03; @(posedge clk); #1;
            data_in = 8'h04; @(posedge clk); #1;
            data_in = 8'h05; @(posedge clk); #1;
            data_in = 8'h06; @(posedge clk); #1;
            data_in = 8'h07; @(posedge clk); #1;
            #1;

            check_outputs(8'h07);
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
        $dumpvars(0,clk, data_in, rst, data_out);
    end

endmodule
