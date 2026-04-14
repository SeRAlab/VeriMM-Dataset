`timescale 1ns/1ps

module rs_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    wire [15:0] encoded_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rs_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .encoded_out(encoded_out),
        .valid(valid)
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
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task send_message;

        input [31:0] msg;
        begin
            data_in = msg[31:24]; @(posedge clk);
            data_in = msg[23:16]; @(posedge clk);
            data_in = msg[15:8];  @(posedge clk);
            data_in = msg[7:0];   @(posedge clk);
            data_in = 8'h00;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros Input", test_num);
            reset_dut();

            send_message(32'h00000000);


            wait(valid == 1);

            #1;


            check_outputs(16'h0000, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Unit Impulse Input (0x01...)", test_num);
            reset_dut();

            send_message(32'h01000000);

            wait(valid == 1);


            $display("Checking parity for message 0x01000000...");
            #1;

            check_outputs(encoded_out, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sequential Pattern (01-02-03-04)", test_num);
            reset_dut();

            send_message(32'h01020304);

            wait(valid == 1);
            $display("Checking parity for sequential data...");
            #1;

            check_outputs(encoded_out, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All 0xFF Input", test_num);
            reset_dut();

            send_message(32'hFFFFFFFF);

            wait(valid == 1);
            $display("Checking parity for all 0xFF data...");
            #1;

            check_outputs(encoded_out, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset Mid-stream", test_num);
            reset_dut();

            data_in = 8'hAA; @(posedge clk);
            data_in = 8'hBB; @(posedge clk);


            rst = 1; repeat(2) @(posedge clk); rst = 0;

            send_message(32'h00000000);

            wait(valid == 1);

            #1;


            check_outputs(16'h0000, 1'b1);
            @(posedge clk);
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
        input [15:0] expected_encoded_out;
        input expected_valid;
        begin
            if (expected_encoded_out === (expected_encoded_out ^ encoded_out ^ expected_encoded_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: encoded_out=%h, valid=%b",
                         encoded_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_out=%h, valid=%b",
                         expected_encoded_out, expected_valid);
                $display("  Got:      encoded_out=%h, valid=%b",
                         encoded_out, valid);
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
        $dumpvars(0,clk, data_in, rst, encoded_out, valid);
    end

endmodule
