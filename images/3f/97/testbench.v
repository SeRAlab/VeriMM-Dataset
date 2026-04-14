`timescale 1ns/1ps

module lzw_compressor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg valid;
    wire [11:0] data_out;
    wire out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lzw_compressor dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .valid(valid),
        .data_out(data_out),
        .out_valid(out_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            valid = 0;
            data_in = 8'h00;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase 001: Pattern Repetition (ABABABA...X)");
            reset_dut();


            @(posedge clk);
            data_in = 8'h41; valid = 1; @(posedge clk);
            data_in = 8'h42; valid = 1; @(posedge clk);
            data_in = 8'h41; valid = 1; @(posedge clk);
            data_in = 8'h42; valid = 1; @(posedge clk);
            data_in = 8'h41; valid = 1; @(posedge clk);
            data_in = 8'h42; valid = 1; @(posedge clk);
            data_in = 8'h41; valid = 1; @(posedge clk);
            data_in = 8'h58; valid = 1; @(posedge clk);
            valid = 0; data_in = 0;


            wait(out_valid);
            #1;

            check_outputs(12'h102, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase 002: Continuous Identical Characters (AAAAAA...X)");
            reset_dut();

            @(posedge clk);
            data_in = 8'h61; valid = 1; @(posedge clk);
            data_in = 8'h61; valid = 1; @(posedge clk);
            data_in = 8'h61; valid = 1; @(posedge clk);
            data_in = 8'h61; valid = 1; @(posedge clk);
            data_in = 8'h61; valid = 1; @(posedge clk);
            data_in = 8'h58; valid = 1; @(posedge clk);
            valid = 0;


            wait(out_valid);
            #1;

            check_outputs(12'h101, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase 003: Simple Literal Sequence");
            reset_dut();

            @(posedge clk);
            data_in = 8'h10; valid = 1; @(posedge clk);
            data_in = 8'h20; valid = 1; @(posedge clk);
            data_in = 8'h30; valid = 1; @(posedge clk);
            data_in = 8'h40; valid = 1; @(posedge clk);
            valid = 0;


            wait(out_valid);
            #1;

            check_outputs(12'h030, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase 004: Dictionary Reset Check");
            reset_dut();


            data_in = 8'hAA; valid = 1; @(posedge clk);
            data_in = 8'hBB; valid = 1; @(posedge clk);
            data_in = 8'hAA; valid = 1; @(posedge clk);
            data_in = 8'hBB; valid = 1; @(posedge clk);
            data_in = 8'hFF; valid = 1; @(posedge clk);
            valid = 0;
            wait(out_valid);


            reset_dut();


            data_in = 8'hCC; valid = 1; @(posedge clk);
            data_in = 8'hDD; valid = 1; @(posedge clk);
            data_in = 8'hCC; valid = 1; @(posedge clk);
            data_in = 8'hDD; valid = 1; @(posedge clk);
            data_in = 8'hEE; valid = 1; @(posedge clk);
            valid = 0;


            wait(out_valid);
            #1;

            check_outputs(12'h100, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lzw_compressor Testbench");
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
        input [11:0] expected_data_out;
        input expected_out_valid;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_out_valid === (expected_out_valid ^ out_valid ^ expected_out_valid)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, out_valid=%b",
                         data_out, out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, out_valid=%b",
                         expected_data_out, expected_out_valid);
                $display("  Got:      data_out=%h, out_valid=%b",
                         data_out, out_valid);
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
        $dumpvars(0,clk, data_in, reset, valid, data_out, out_valid);
    end

endmodule
