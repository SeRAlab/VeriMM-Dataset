`timescale 1ns/1ps

module ofdm_bpsk_modulator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg enable;
    reg reset;
    wire [1:0] data_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ofdm_bpsk_modulator dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .reset(reset),
        .data_out(data_out),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            data_in = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Modulate bit 0 (Logic 0)", test_num);
            reset_dut();

            data_in = 8'b00000000;
            enable = 1;

            @(posedge clk);
            #2;


            #1;



            check_outputs(2'b01, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Modulate bit 0 (Logic 1)", test_num);
            reset_dut();

            data_in = 8'b00000001;
            enable = 1;

            @(posedge clk);
            #2;


            #1;



            check_outputs(2'b11, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Enable Low Check", test_num);
            reset_dut();

            data_in = 8'b00000001;
            enable = 0;

            @(posedge clk);
            #2;


            #1;



            check_outputs(data_out, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Modulate MSB/Other bits (Checking bit 0 focus)", test_num);
            reset_dut();



            data_in = 8'b11111110;
            enable = 1;

            @(posedge clk);
            #2;


            #1;



            check_outputs(2'b01, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset behavior during active Enable", test_num);
            reset_dut();

            enable = 1;
            data_in = 8'b00000001;
            @(posedge clk);
            #1;

            reset = 1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(2'b00, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ofdm_bpsk_modulator Testbench");
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
        input [1:0] expected_data_out;
        input expected_valid;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, valid=%b",
                         data_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, valid=%b",
                         expected_data_out, expected_valid);
                $display("  Got:      data_out=%h, valid=%b",
                         data_out, valid);
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
        $dumpvars(0,clk, data_in, enable, reset, data_out, valid);
    end

endmodule
