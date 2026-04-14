`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] data_in;
    reg enable;
    wire [15:0] data_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .enable(enable),
        .data_out(data_out),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        enable = 0;
        forever #5 enable = ~enable;
    end

        task reset_dut;

        begin
            data_in = 16'h0;


            @(negedge enable);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase001: Input 0x0000 -> Expected 0xF000, Valid 1");
            reset_dut();
            data_in = 16'h0000;

            @(posedge enable);
            #2;
            #1;

            check_outputs(16'hF000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase002: Input 0xFFFF -> Expected 0x0FFF, Valid 1");
            reset_dut();
            data_in = 16'hFFFF;
            @(posedge enable);
            #2;
            #1;

            check_outputs(16'h0FFF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase003: Input 0x1234 -> Expected 0xE234, Valid 1");
            reset_dut();
            data_in = 16'h1234;
            @(posedge enable);
            #2;
            #1;

            check_outputs(16'hE234, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase004: Input 0xABCD -> Expected 0x5BCD, Valid 1");
            reset_dut();
            data_in = 16'hABCD;
            @(posedge enable);
            #2;
            #1;

            check_outputs(16'h5BCD, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase005: Input 0x5555 -> Expected 0xA555, Valid 1");
            reset_dut();
            data_in = 16'h5555;
            @(posedge enable);
            #2;
            #1;

            check_outputs(16'hA555, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase006: Verify 'valid' resets on negative edge of enable");
            reset_dut();
            data_in = 16'h1111;
            @(posedge enable);
            #2;
            if (valid !== 1'b1) $display("FAIL: Valid should be 1 after posedge");

            @(negedge enable);
            #2;



            #1;




            check_outputs(data_out, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase007: Input 0x8000 (MSB set) -> Expected 0x7000, Valid 1");
            reset_dut();
            data_in = 16'h8000;
            @(posedge enable);
            #2;
            #1;

            check_outputs(16'h7000, 1'b1);
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
        testcase006();
        testcase007();
        
        
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
        input [15:0] expected_data_out;
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
        $dumpvars(0,data_in, enable, data_out, valid);
    end

endmodule
