`timescale 1ns/1ps

module SIPO_Shift_Register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg serial_in;
    wire [4:0] parallel_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SIPO_Shift_Register dut (
        .clk(clk),
        .reset(reset),
        .serial_in(serial_in),
        .parallel_out(parallel_out),
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
            serial_in = 0;
            @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Shift in all ones (11111)", test_num);
            reset_dut();


            repeat(5) begin
                serial_in = 1'b1;
                @(negedge clk);
            end

            #1;


            check_outputs(5'b11111, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Shift in pattern 10101", test_num);
            reset_dut();


            serial_in = 1'b1; @(negedge clk);

            serial_in = 1'b0; @(negedge clk);

            serial_in = 1'b1; @(negedge clk);

            serial_in = 1'b0; @(negedge clk);

            serial_in = 1'b1; @(negedge clk);

            #1;


            check_outputs(5'b10101, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Shift in pattern 01100", test_num);
            reset_dut();

            serial_in = 1'b0; @(negedge clk);
            serial_in = 1'b1; @(negedge clk);
            serial_in = 1'b1; @(negedge clk);
            serial_in = 1'b0; @(negedge clk);
            serial_in = 1'b0; @(negedge clk);

            #1;


            check_outputs(5'b01100, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Shift in all zeros (00000)", test_num);
            reset_dut();

            repeat(5) begin
                serial_in = 1'b0;
                @(negedge clk);
            end

            #1;


            check_outputs(5'b00000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Reset during shift sequence", test_num);
            reset_dut();


            serial_in = 1'b1; @(negedge clk);
            serial_in = 1'b1; @(negedge clk);
            serial_in = 1'b1; @(negedge clk);


            reset = 1;
            @(negedge clk);
            reset = 0;


            serial_in = 1'b0; @(negedge clk);
            serial_in = 1'b0; @(negedge clk);
            serial_in = 1'b0; @(negedge clk);
            serial_in = 1'b0; @(negedge clk);
            serial_in = 1'b1; @(negedge clk);


            #1;



            check_outputs(5'b00001, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Check valid remains LOW at 4 bits", test_num);
            reset_dut();


            repeat(4) begin
                serial_in = 1'b1;
                @(negedge clk);
            end


            if (valid === 1'b0) begin
                $display("PASS: Valid is low as expected after 4 bits.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Valid is high before 5 bits received.");
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
        $display("SIPO_Shift_Register Testbench");
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
        input [4:0] expected_parallel_out;
        input expected_valid;
        begin
            if (expected_parallel_out === (expected_parallel_out ^ parallel_out ^ expected_parallel_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: parallel_out=%h, valid=%b",
                         parallel_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parallel_out=%h, valid=%b",
                         expected_parallel_out, expected_valid);
                $display("  Got:      parallel_out=%h, valid=%b",
                         parallel_out, valid);
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
        $dumpvars(0,clk, reset, serial_in, parallel_out, valid);
    end

endmodule
