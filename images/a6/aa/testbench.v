`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg [31:0] encoded_in;
    reg [3:0] id_in;
    wire [3:0] data_out;
    wire [31:0] encoded_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .encoded_in(encoded_in),
        .id_in(id_in),
        .data_out(data_out),
        .encoded_out(encoded_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_in = 4'b0;
            id_in = 4'b0;
            encoded_in = 32'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Basic Loopback ID=0xA, Data=0x5", test_num);
            id_in = 4'hA;
            data_in = 4'h5;
            @(posedge clk);
            #2;
            encoded_in = encoded_out;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h5, encoded_out);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Loopback ID=0xF, Data=0xA", test_num);
            id_in = 4'hF;
            data_in = 4'hA;
            @(posedge clk);
            #2;
            encoded_in = encoded_out;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'hA, encoded_out);
        end
        endtask

    task testcase003;

        reg [31:0] captured_encoded;
        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: ID Mismatch Test", test_num);


            id_in = 4'hC;
            data_in = 4'h7;
            @(posedge clk);
            #2;
            captured_encoded = encoded_out;


            id_in = 4'hD;
            encoded_in = captured_encoded;
            repeat(2) @(posedge clk);
            #1;


            if (data_out !== 4'h7) begin
                $display("PASS: Decoder correctly ignored mismatched ID");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Decoder accepted mismatched ID");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: All Zeros Data", test_num);
            id_in = 4'h1;
            data_in = 4'h0;
            @(posedge clk);
            #2;
            encoded_in = encoded_out;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0, encoded_out);
        end
        endtask

    task testcase005;

        reg [31:0] corrupted_frame;
        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Corrupted Packet (Invalid framing)", test_num);
            id_in = 4'hE;
            data_in = 4'h9;
            @(posedge clk);
            #2;

            corrupted_frame = encoded_out ^ 32'h80000000;
            encoded_in = corrupted_frame;
            repeat(2) @(posedge clk);
            #1;

            if (data_out !== 4'h9) begin
                $display("PASS: Decoder ignored corrupted frame");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Decoder accepted corrupted frame");
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
        $display("top_module Testbench");
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
        input [3:0] expected_data_out;
        input [31:0] expected_encoded_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_encoded_out === (expected_encoded_out ^ encoded_out ^ expected_encoded_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, encoded_out=%h",
                         data_out, encoded_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, encoded_out=%h",
                         expected_data_out, expected_encoded_out);
                $display("  Got:      data_out=%h, encoded_out=%h",
                         data_out, encoded_out);
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
        $dumpvars(0,clk, data_in, encoded_in, id_in, data_out, encoded_out);
    end

endmodule
