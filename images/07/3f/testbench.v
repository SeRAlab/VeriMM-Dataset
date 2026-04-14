`timescale 1ns/1ps

module rs_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg data_valid;
    reg rst;
    wire [7:0] encoded_out;
    wire encoded_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rs_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .rst(rst),
        .encoded_out(encoded_out),
        .encoded_valid(encoded_valid)
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
            data_valid = 0;
            repeat (5) @(posedge clk);
            rst = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros Data", test_num);
            reset_dut();


            @(posedge clk);
            data_valid = 1;
            data_in = 8'h00; @(posedge clk);
            data_in = 8'h00; @(posedge clk);
            data_in = 8'h00; @(posedge clk);
            data_in = 8'h00; @(posedge clk);
            data_valid = 0;
            data_in = 8'h00;



            repeat(5) @(posedge clk);
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Incremental Data", test_num);
            reset_dut();

            @(posedge clk);
            data_valid = 1;
            data_in = 8'h01; @(posedge clk);
            data_in = 8'h02; @(posedge clk);
            data_in = 8'h03; @(posedge clk);
            data_in = 8'h04; @(posedge clk);
            data_valid = 0;




            repeat(5) @(posedge clk);



            if (encoded_valid === 1'b1) begin
                $display("Final Parity Output detected.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: encoded_valid not high at expected parity interval");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: High Bit Pattern", test_num);
            reset_dut();

            @(posedge clk);
            data_valid = 1;
            data_in = 8'hFF; @(posedge clk);
            data_in = 8'h00; @(posedge clk);
            data_in = 8'hFF; @(posedge clk);
            data_in = 8'h00; @(posedge clk);
            data_valid = 0;


            repeat(5) @(posedge clk);


            if (encoded_valid === 1'b1 || encoded_valid === 1'b0) begin
                $display("Sequence completed. Final encoded_out: %h", encoded_out);
                pass_count = pass_count + 1;
            end else begin
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset Recovery", test_num);
            reset_dut();

            @(posedge clk);
            data_valid = 1;
            data_in = 8'hAA; @(posedge clk);
            data_in = 8'hBB; @(posedge clk);


            rst = 1; @(posedge clk);
            rst = 0; @(posedge clk);


            if (encoded_out === 8'h00 && encoded_valid === 1'b0) begin
                $display("PASS: Encoder reset correctly mid-stream");
                pass_count = pass_count + 1;
            } else begin
                $display("FAIL: Encoder did not clear output on reset");
                fail_count = fail_count + 1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rs_encoder Testbench");
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
        input [7:0] expected_encoded_out;
        input expected_encoded_valid;
        begin
            if (expected_encoded_out === (expected_encoded_out ^ encoded_out ^ expected_encoded_out) &&
                expected_encoded_valid === (expected_encoded_valid ^ encoded_valid ^ expected_encoded_valid)) begin
                $display("PASS");
                $display("  Outputs: encoded_out=%h, encoded_valid=%b",
                         encoded_out, encoded_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_out=%h, encoded_valid=%b",
                         expected_encoded_out, expected_encoded_valid);
                $display("  Got:      encoded_out=%h, encoded_valid=%b",
                         encoded_out, encoded_valid);
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
        $dumpvars(0,clk, data_in, data_valid, rst, encoded_out, encoded_valid);
    end

endmodule
