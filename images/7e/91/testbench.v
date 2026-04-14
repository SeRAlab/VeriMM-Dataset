`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_i;
    reg decrypt_i;
    reg reset;
    reg [7:0] sbox_data_i;
    reg start_i;
    wire [31:0] data_o;
    wire ready_o;
    wire [7:0] sbox_data_o;
    wire sbox_decrypt_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_i(data_i),
        .decrypt_i(decrypt_i),
        .reset(reset),
        .sbox_data_i(sbox_data_i),
        .start_i(start_i),
        .data_o(data_o),
        .ready_o(ready_o),
        .sbox_data_o(sbox_data_o),
        .sbox_decrypt_o(sbox_decrypt_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start_i = 0;
            decrypt_i = 0;
            data_i = 0;
            sbox_data_i = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Encryption 0x00112233");
            reset_dut();
            data_i = 32'h00112233;
            decrypt_i = 0;
            start_i = 1;
            @(posedge clk);
            #1 start_i = 0;

            timeout = 0;
            while (!ready_o && timeout < 50) begin
                sbox_data_i = aes_sbox(sbox_data_o);
                @(posedge clk);
                #1 timeout = timeout + 1;
            end



            #1;




            check_outputs(32'h638293c3, 1'b1, 8'h33, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Decryption 0x638293c3");
            reset_dut();
            data_i = 32'h638293c3;
            decrypt_i = 1;
            start_i = 1;
            @(posedge clk);
            #1 start_i = 0;

            timeout = 0;
            while (!ready_o && timeout < 50) begin
                sbox_data_i = aes_inv_sbox(sbox_data_o);
                @(posedge clk);
                #1 timeout = timeout + 1;
            end



            #1;




            check_outputs(32'h00112233, 1'b1, 8'hc3, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Encryption 0x44556677");
            reset_dut();
            data_i = 32'h44556677;
            decrypt_i = 0;
            start_i = 1;
            @(posedge clk);
            #1 start_i = 0;

            timeout = 0;
            while (!ready_o && timeout < 50) begin
                sbox_data_i = aes_sbox(sbox_data_o);
                @(posedge clk);
                #1 timeout = timeout + 1;
            end


            #1;



            check_outputs(32'h1bfc33f5, 1'b1, 8'h77, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Idle State Check");
            reset_dut();

            #1;


            check_outputs(data_o, 1'b0, sbox_data_o, 1'b0);
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
        input [31:0] expected_data_o;
        input expected_ready_o;
        input [7:0] expected_sbox_data_o;
        input expected_sbox_decrypt_o;
        begin
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o) &&
                expected_ready_o === (expected_ready_o ^ ready_o ^ expected_ready_o) &&
                expected_sbox_data_o === (expected_sbox_data_o ^ sbox_data_o ^ expected_sbox_data_o) &&
                expected_sbox_decrypt_o === (expected_sbox_decrypt_o ^ sbox_decrypt_o ^ expected_sbox_decrypt_o)) begin
                $display("PASS");
                $display("  Outputs: data_o=%h, ready_o=%b, sbox_data_o=%h, sbox_decrypt_o=%b",
                         data_o, ready_o, sbox_data_o, sbox_decrypt_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%h, ready_o=%b, sbox_data_o=%h, sbox_decrypt_o=%b",
                         expected_data_o, expected_ready_o, expected_sbox_data_o, expected_sbox_decrypt_o);
                $display("  Got:      data_o=%h, ready_o=%b, sbox_data_o=%h, sbox_decrypt_o=%b",
                         data_o, ready_o, sbox_data_o, sbox_decrypt_o);
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
        $dumpvars(0,clk, data_i, decrypt_i, reset, sbox_data_i, start_i, data_o, ready_o, sbox_data_o, sbox_decrypt_o);
    end

endmodule
