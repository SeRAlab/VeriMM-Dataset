`timescale 1ns/1ps

module reed_solomon_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg rst;
    reg valid;
    wire [6:0] encoded_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reed_solomon_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .valid(valid),
        .encoded_out(encoded_out)
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
            valid = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task drive_input;

        input [3:0] data;
        begin
            @(posedge clk);
            #1;
            data_in = data;
            valid = 1;
            @(posedge clk);
            #1;
            valid = 0;

            repeat(2) @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Data Input 4'b0000", test_num);
            reset_dut();
            drive_input(4'b0000);

            #1;


            check_outputs(7'b0000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Data Input 4'b1000", test_num);
            reset_dut();
            drive_input(4'b1000);

            #1;


            check_outputs(7'b1000110);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Data Input 4'b0001", test_num);
            reset_dut();
            drive_input(4'b0001);
            #1;

            check_outputs(7'b0001101);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Data Input 4'b1111", test_num);
            reset_dut();
            drive_input(4'b1111);
            #1;

            check_outputs(7'b1111111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Data Input 4'b1010", test_num);
            reset_dut();
            drive_input(4'b1010);
            #1;

            check_outputs(7'b1010001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Data Input 4'b0101", test_num);
            reset_dut();
            drive_input(4'b0101);
            #1;

            check_outputs(7'b0101110);
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
        input [6:0] expected_encoded_out;
        begin
            if (expected_encoded_out === (expected_encoded_out ^ encoded_out ^ expected_encoded_out)) begin
                $display("PASS");
                $display("  Outputs: encoded_out=%h",
                         encoded_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_out=%h",
                         expected_encoded_out);
                $display("  Got:      encoded_out=%h",
                         encoded_out);
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
        $dumpvars(0,clk, data_in, rst, valid, encoded_out);
    end

endmodule
