`timescale 1ns/1ps

module error_correction_arq_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg data_valid;
    reg rst;
    wire data_out;
    wire error_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    error_correction_arq dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .rst(rst),
        .data_out(data_out),
        .error_flag(error_flag)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 0;
            data_valid = 0;
            repeat (2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Immediate valid data", test_num);
            reset_dut();

            data_in = 1'b1;
            data_valid = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single retry scenario", test_num);
            reset_dut();


            data_in = 1'b1;
            data_valid = 1'b0;
            @(posedge clk);


            #1;
            data_in = 1'b1;
            data_valid = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Multiple retries", test_num);
            reset_dut();


            data_in = 1'b0;
            data_valid = 1'b0;
            @(posedge clk);


            #1;
            data_in = 1'b1;
            data_valid = 1'b0;
            @(posedge clk);


            #1;
            data_in = 1'b0;
            data_valid = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verify flag clears after correction", test_num);
            reset_dut();

            data_in = 1'b1;
            data_valid = 1'b0;
            @(posedge clk);


            #1;
            data_in = 1'b1;
            data_valid = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Sequence of valid data", test_num);
            reset_dut();

            data_in = 1'b1;
            data_valid = 1'b1;
            @(posedge clk);

            #1;
            data_in = 1'b0;
            data_valid = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Reset during error state", test_num);
            reset_dut();

            data_in = 1'b1;
            data_valid = 1'b0;
            @(posedge clk);


            reset_dut();

            data_in = 1'b0;
            data_valid = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("error_correction_arq Testbench");
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
        input expected_data_out;
        input expected_error_flag;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_error_flag === (expected_error_flag ^ error_flag ^ expected_error_flag)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b, error_flag=%b",
                         data_out, error_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b, error_flag=%b",
                         expected_data_out, expected_error_flag);
                $display("  Got:      data_out=%b, error_flag=%b",
                         data_out, error_flag);
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
        $dumpvars(0,clk, data_in, data_valid, rst, data_out, error_flag);
    end

endmodule
