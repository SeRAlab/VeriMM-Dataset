`timescale 1ns/1ps

module mem_encrypt_decrypt_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg enable;
    reg [7:0] key;
    reg reset;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mem_encrypt_decrypt dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .key(key),
        .reset(reset),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 8'h0;
            key = 8'h0;
            enable = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bypass Mode", test_num);
            reset_dut();

            data_in = 8'hA5;
            key = 8'hFF;
            enable = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Encryption Mode (XOR)", test_num);
            reset_dut();

            data_in = 8'h55;
            key = 8'hAA;
            enable = 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55 ^ 8'hAA);
        end
        endtask

    task testcase003;

        reg [7:0] encrypted_val;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Decryption Logic", test_num);
            reset_dut();


            data_in = 8'h12;
            key = 8'h34;
            enable = 1;
            @(posedge clk);
            #1 encrypted_val = data_out;


            data_in = encrypted_val;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Key Change Behavior", test_num);
            reset_dut();

            data_in = 8'hFF;
            key = 8'h00;
            enable = 1;

            @(posedge clk);
            #1;
            if (data_out == 8'hFF) begin

                key = 8'hFF;
                @(posedge clk);
                #1;
                #1;

                check_outputs(8'h00);
            end else begin
                #1;

                check_outputs(8'hFF);
            end
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Synchronous Reset Check", test_num);
            reset_dut();

            data_in = 8'hCC;
            key = 8'h33;
            enable = 1;

            @(posedge clk);
            #1;

            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary Values (All 1s)", test_num);
            reset_dut();

            data_in = 8'hFF;
            key = 8'hFF;
            enable = 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mem_encrypt_decrypt Testbench");
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
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, enable, key, reset, data_out);
    end

endmodule
