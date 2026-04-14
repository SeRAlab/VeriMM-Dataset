`timescale 1ns/1ps

module min_detect_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst_n;
    reg valid_in;
    wire [7:0] data_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    min_detect dut (
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
            data_in = 0;
            valid_in = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task send_byte;

        input [7:0] val;
        begin
            @(posedge clk);
            #1;
            data_in = val;
            valid_in = 1;
            @(posedge clk);
            #1;
            valid_in = 0;
            data_in = 8'h00;
        end
        endtask

    task wait_and_verify;

        input [7:0] expected_min;
        begin

            while (valid_out !== 1'b1) @(posedge clk);

            #1;
            #1;

            check_outputs(expected_min, 1'b1);
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Smallest value first (10, 20, 30, 40)", test_num);
            send_byte(8'd10);
            send_byte(8'd20);
            send_byte(8'd30);
            send_byte(8'd40);
            wait_and_verify(8'd10);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Smallest value last (80, 70, 60, 50)", test_num);
            send_byte(8'd80);
            send_byte(8'd70);
            send_byte(8'd60);
            send_byte(8'd50);
            wait_and_verify(8'd50);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Smallest value in middle (100, 5, 200, 50)", test_num);
            send_byte(8'd100);
            send_byte(8'd5);
            send_byte(8'd200);
            send_byte(8'd50);
            wait_and_verify(8'd5);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: All values identical (255, 255, 255, 255)", test_num);
            send_byte(8'hFF);
            send_byte(8'hFF);
            send_byte(8'hFF);
            send_byte(8'hFF);
            wait_and_verify(8'hFF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Minimum value is zero (128, 0, 255, 64)", test_num);
            send_byte(8'd128);
            send_byte(8'd0);
            send_byte(8'd255);
            send_byte(8'd64);
            wait_and_verify(8'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Duplicate minimums (15, 30, 15, 45)", test_num);
            send_byte(8'd15);
            send_byte(8'd30);
            send_byte(8'd15);
            send_byte(8'd45);
            wait_and_verify(8'd15);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("min_detect Testbench");
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
        input [7:0] expected_data_out;
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
