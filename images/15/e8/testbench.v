`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg data_in_valid;
    reg [7:0] received_data;
    reg received_data_valid;
    reg reset;
    wire [7:0] data_out;
    wire data_out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .data_in(data_in),
        .data_in_valid(data_in_valid),
        .received_data(received_data),
        .received_data_valid(received_data_valid),
        .reset(reset),
        .data_out(data_out),
        .data_out_valid(data_out_valid)
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
            data_in_valid = 0;
            received_data = 8'h0;
            received_data_valid = 0;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Reset State Verification");
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Single Byte Transmission (0xA5)");
            reset_dut();

            @(posedge clk);
            data_in = 8'hA5;
            data_in_valid = 1'b1;


            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Multi-byte Sequence (0x11 -> 0x22 -> 0x33)");
            reset_dut();

            @(posedge clk);
            data_in = 8'h11; data_in_valid = 1'b1;
            @(posedge clk);
            data_in = 8'h22;
            @(posedge clk);
            data_in = 8'h33;

            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h33, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Transmission Deassertion (Idle)");
            reset_dut();


            @(posedge clk);
            data_in = 8'hFF;
            data_in_valid = 1'b1;
            @(posedge clk);


            data_in_valid = 1'b0;
            data_in = 8'h00;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Simultaneous TX and RX Activity");
            reset_dut();

            @(posedge clk);

            received_data = 8'hBC;
            received_data_valid = 1'b1;
            data_in = 8'h44;
            data_in_valid = 1'b1;

            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h44, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ethernet_mac_controller Testbench");
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
        input [7:0] expected_data_out;
        input expected_data_out_valid;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_data_out_valid === (expected_data_out_valid ^ data_out_valid ^ expected_data_out_valid)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, data_out_valid=%b",
                         data_out, data_out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, data_out_valid=%b",
                         expected_data_out, expected_data_out_valid);
                $display("  Got:      data_out=%h, data_out_valid=%b",
                         data_out, data_out_valid);
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
        $dumpvars(0,clk, data_in, data_in_valid, received_data, received_data_valid, reset, data_out, data_out_valid);
    end

endmodule
