`timescale 1ns/1ps

module turbo_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] data_in;
    reg reset;
    reg valid_in;
    wire [3:0] encoded_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    turbo_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .valid_in(valid_in),
        .encoded_out(encoded_out),
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
            data_in = 2'b00;
            valid_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros Pattern", test_num);
            reset_dut();

            data_in = 2'b00;
            valid_in = 1;
            @(posedge clk);
            #1 valid_in = 0;


            wait(valid_out == 1);
            #1;

            check_outputs(4'b0000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones Pattern", test_num);
            reset_dut();

            data_in = 2'b11;
            valid_in = 1;
            @(posedge clk);
            #1 valid_in = 0;

            wait(valid_out == 1);



            #1;




            check_outputs(4'b1111, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Pattern 10", test_num);
            reset_dut();

            data_in = 2'b10;
            valid_in = 1;
            @(posedge clk);
            #1 valid_in = 0;

            wait(valid_out == 1);
            #1;

            check_outputs(4'b1010, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Pattern 01", test_num);
            reset_dut();

            data_in = 2'b01;
            valid_in = 1;
            @(posedge clk);
            #1 valid_in = 0;

            wait(valid_out == 1);
            #1;

            check_outputs(4'b0101, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequential Data Stream (11 then 00)", test_num);
            reset_dut();


            data_in = 2'b11;
            valid_in = 1;
            @(posedge clk);
            #1;


            data_in = 2'b00;
            valid_in = 1;
            @(posedge clk);
            #1 valid_in = 0;


            wait(valid_out == 1);
            @(posedge clk);

            #1;


            check_outputs(4'b1100, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("turbo_encoder Testbench");
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
        input [3:0] expected_encoded_out;
        input expected_valid_out;
        begin
            if (expected_encoded_out === (expected_encoded_out ^ encoded_out ^ expected_encoded_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: encoded_out=%h, valid_out=%b",
                         encoded_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_out=%h, valid_out=%b",
                         expected_encoded_out, expected_valid_out);
                $display("  Got:      encoded_out=%h, valid_out=%b",
                         encoded_out, valid_out);
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
        $dumpvars(0,clk, data_in, reset, valid_in, encoded_out, valid_out);
    end

endmodule
