`timescale 1ns/1ps

module ShiftRows_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] data_in;
    reg reset;
    reg valid_in;
    wire [127:0] data_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ShiftRows dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .valid_in(valid_in),
        .data_out(data_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            valid_in = 0;
            data_in = 0;
            #10;
            reset = 0;
            #20;
            reset = 1;
            #10;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Running Testcase %0d: All Zeros", test_num);
            data_in = 128'h0;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;


            while (!valid_out) @(posedge clk);

            #1;


            check_outputs(128'h0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Running Testcase %0d: All Ones", test_num);
            data_in = 128'hffffffffffffffffffffffffffffffff;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;

            while (!valid_out) @(posedge clk);

            #1;


            check_outputs(128'hffffffffffffffffffffffffffffffff, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Running Testcase %0d: FIPS-197 Standard Vector", test_num);
            data_in = 128'hd4e0b81ebfb441275d52119830aef1e5;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;

            while (!valid_out) @(posedge clk);

            #1;


            check_outputs(128'hd4b411e5bf52f11e5daeb82730e04198, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Running Testcase %0d: Linear Ramp Sequence", test_num);
            data_in = 128'h000102030405060708090a0b0c0d0e0f;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;

            while (!valid_out) @(posedge clk);

            #1;


            check_outputs(128'h00050a0f04090e03080d02070c01060b, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Running Testcase %0d: Patterned Byte Input", test_num);
            data_in = 128'h55aa55aa33cc33cc55aa55aa33cc33cc;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;

            while (!valid_out) @(posedge clk);

            #1;


            check_outputs(128'h55cc55cc33aa33aa55cc55cc33aa33aa, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ShiftRows Testbench");
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
        input [127:0] expected_data_out;
        input expected_valid_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, valid_out=%b",
                         data_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, valid_out=%b",
                         expected_data_out, expected_valid_out);
                $display("  Got:      data_out=%h, valid_out=%b",
                         data_out, valid_out);
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
        $dumpvars(0,clk, data_in, reset, valid_in, data_out, valid_out);
    end

endmodule
