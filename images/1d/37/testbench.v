`timescale 1ns/1ps

module lzw_compression_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg valid_in;
    wire [7:0] code_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lzw_compression dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .valid_in(valid_in),
        .code_out(code_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            valid_in = 0;
            data_in = 8'h0;
            repeat(5) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Byte Input", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 8'h41;
            valid_in = 1;
            @(posedge clk);
            data_in = 8'h42;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;


            repeat (10) begin
                if (valid_out) break;
                @(posedge clk);
            end

            #1;


            check_outputs(8'h41, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Repeated Character", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 8'h55;
            valid_in = 1;
            @(posedge clk);
            data_in = 8'h55;
            valid_in = 1;
            @(posedge clk);
            data_in = 8'h11;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;


            repeat (10) begin
                if (valid_out) break;
                @(posedge clk);
            end

            #1;


            check_outputs(8'h55, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Unique Byte Stream", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 8'h01; valid_in = 1;
            @(posedge clk);
            data_in = 8'h02; valid_in = 1;
            @(posedge clk);
            data_in = 8'h03; valid_in = 1;
            @(posedge clk);
            valid_in = 0;


            repeat (10) begin
                if (valid_out) break;
                @(posedge clk);
            end
            #1;

            check_outputs(8'h01, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Valid Signal Toggling", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 8'hAA; valid_in = 1;
            @(posedge clk);
            valid_in = 0;
            repeat(3) @(posedge clk);
            data_in = 8'hBB; valid_in = 1;
            @(posedge clk);
            valid_in = 0;

            repeat (10) begin
                if (valid_out) break;
                @(posedge clk);
            end
            #1;

            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Boundary Values (0x00 and 0xFF)", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 8'hFF; valid_in = 1;
            @(posedge clk);
            data_in = 8'h00; valid_in = 1;
            @(posedge clk);
            valid_in = 0;

            repeat (10) begin
                if (valid_out) break;
                @(posedge clk);
            end
            #1;

            check_outputs(8'hFF, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lzw_compression Testbench");
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
        input [7:0] expected_code_out;
        input expected_valid_out;
        begin
            if (expected_code_out === (expected_code_out ^ code_out ^ expected_code_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: code_out=%h, valid_out=%b",
                         code_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: code_out=%h, valid_out=%b",
                         expected_code_out, expected_valid_out);
                $display("  Got:      code_out=%h, valid_out=%b",
                         code_out, valid_out);
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
        $dumpvars(0,clk, data_in, rst, valid_in, code_out, valid_out);
    end

endmodule
