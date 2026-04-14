`timescale 1ns/1ps

module reed_solomon_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg data_valid;
    reg rst;
    wire [7:0] encoded_out;
    wire encoding_done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reed_solomon_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .rst(rst),
        .encoded_out(encoded_out),
        .encoding_done(encoding_done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 4'b0;
            data_valid = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: All Zeros");
            test_num = test_num + 1;
            reset_dut();

            data_valid = 1;
            data_in = 4'h0; @(posedge clk);
            data_in = 4'h0; @(posedge clk);
            data_in = 4'h0; @(posedge clk);
            data_in = 4'h0; @(posedge clk);
            data_valid = 0;

            wait(encoding_done);
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Sequence 1, 2, 3, 4");
            test_num = test_num + 1;
            reset_dut();

            data_valid = 1;
            data_in = 4'h1; @(posedge clk);
            data_in = 4'h2; @(posedge clk);
            data_in = 4'h3; @(posedge clk);
            data_in = 4'h4; @(posedge clk);
            data_valid = 0;

            wait(encoding_done);
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: All F's");
            test_num = test_num + 1;
            reset_dut();

            data_valid = 1;
            data_in = 4'hF; @(posedge clk);
            data_in = 4'hF; @(posedge clk);
            data_in = 4'hF; @(posedge clk);
            data_in = 4'hF; @(posedge clk);
            data_valid = 0;

            wait(encoding_done);
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h72, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Powers of 2");
            test_num = test_num + 1;
            reset_dut();

            data_valid = 1;
            data_in = 4'h1; @(posedge clk);
            data_in = 4'h2; @(posedge clk);
            data_in = 4'h4; @(posedge clk);
            data_in = 4'h8; @(posedge clk);
            data_valid = 0;

            wait(encoding_done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hBC, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Alternating 5 and A");
            test_num = test_num + 1;
            reset_dut();

            data_valid = 1;
            data_in = 4'h5; @(posedge clk);
            data_in = 4'hA; @(posedge clk);
            data_in = 4'h5; @(posedge clk);
            data_in = 4'hA; @(posedge clk);
            data_valid = 0;

            wait(encoding_done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h3D, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reed_solomon_encoder Testbench");
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
        input [7:0] expected_encoded_out;
        input expected_encoding_done;
        begin
            if (expected_encoded_out === (expected_encoded_out ^ encoded_out ^ expected_encoded_out) &&
                expected_encoding_done === (expected_encoding_done ^ encoding_done ^ expected_encoding_done)) begin
                $display("PASS");
                $display("  Outputs: encoded_out=%h, encoding_done=%b",
                         encoded_out, encoding_done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_out=%h, encoding_done=%b",
                         expected_encoded_out, expected_encoding_done);
                $display("  Got:      encoded_out=%h, encoding_done=%b",
                         encoded_out, encoding_done);
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
        $dumpvars(0,clk, data_in, data_valid, rst, encoded_out, encoding_done);
    end

endmodule
