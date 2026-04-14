`timescale 1ns/1ps

module bit_count_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst_n;
    reg valid_in;
    wire [5:0] data_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bit_count dut (
        .clk(clk),
        .data_in(data_in),
        .rst_n(rst_n),
        .valid_in(valid_in),
        .data_out(data_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            data_in = 8'h0;
            valid_in = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: All Zeros...");
            reset_dut();
            repeat(4) begin
                data_in = 8'h00;
                valid_in = 1;
                @(posedge clk);
            end
            valid_in = 0;
            #1;
            #1;

            check_outputs(6'd0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: All Ones (Count 32)...");
            reset_dut();
            repeat(4) begin
                data_in = 8'hFF;
                valid_in = 1;
                @(posedge clk);
            end
            valid_in = 0;
            #1;
            #1;

            check_outputs(6'd32, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Mixed continuous...");
            reset_dut();
            data_in = 8'h01; valid_in = 1; @(posedge clk);
            data_in = 8'h03; valid_in = 1; @(posedge clk);
            data_in = 8'h07; valid_in = 1; @(posedge clk);
            data_in = 8'h0F; valid_in = 1; @(posedge clk);
            valid_in = 0;
            #1;
            #1;

            check_outputs(6'd10, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Intermittent valid_in...");
            reset_dut();
            data_in = 8'h55; valid_in = 1; @(posedge clk);
            valid_in = 0; @(posedge clk);
            data_in = 8'hAA; valid_in = 1; @(posedge clk);
            valid_in = 0; repeat(2) @(posedge clk);
            data_in = 8'h0F; valid_in = 1; @(posedge clk);
            data_in = 8'hF0; valid_in = 1; @(posedge clk);
            valid_in = 0;
            #1;
            #1;

            check_outputs(6'd16, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Consecutive operations...");
            reset_dut();

            repeat(4) begin
                data_in = 8'h01; valid_in = 1; @(posedge clk);
            end
            valid_in = 0; #1;
            if (data_out !== 6'd4 || valid_out !== 1'b1) fail_count = fail_count + 1;


            @(posedge clk);
            repeat(4) begin
                data_in = 8'h03; valid_in = 1; @(posedge clk);
            end
            valid_in = 0; #1;
            #1;

            check_outputs(6'd8, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bit_count Testbench");
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
        input [5:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, rst_n, valid_in, data_out, valid_out);
    end

endmodule
