`timescale 1ns/1ps

module deserializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] parallel_in;
    reg reset;
    wire [15:0] serial_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deserializer dut (
        .clk(clk),
        .parallel_in(parallel_in),
        .reset(reset),
        .serial_out(serial_out),
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
            parallel_in = 8'h00;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: Basic data pattern 0x1234", test_num);
            reset_dut();


            parallel_in = 8'h12;
            @(posedge clk);
            #1;


            parallel_in = 8'h34;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h1234, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: Alternating bits 0xAA55", test_num);
            reset_dut();

            parallel_in = 8'hAA;
            @(posedge clk);
            #1;

            parallel_in = 8'h55;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hAA55, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: All ones 0xFFFF", test_num);
            reset_dut();

            parallel_in = 8'hFF;
            @(posedge clk);
            #1;

            parallel_in = 8'hFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hFFFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: All zeros 0x0000", test_num);
            reset_dut();

            parallel_in = 8'h00;
            @(posedge clk);
            #1;

            parallel_in = 8'h00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: Sequence 0xDEAD", test_num);
            reset_dut();

            parallel_in = 8'hDE;
            @(posedge clk);
            #1;

            parallel_in = 8'hAD;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hDEAD, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: MSB and LSB boundary 0x8001", test_num);
            reset_dut();

            parallel_in = 8'h80;
            @(posedge clk);
            #1;

            parallel_in = 8'h01;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h8001, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deserializer Testbench");
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
        input [15:0] expected_serial_out;
        input expected_valid;
        begin
            if (expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: serial_out=%h, valid=%b",
                         serial_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: serial_out=%h, valid=%b",
                         expected_serial_out, expected_valid);
                $display("  Got:      serial_out=%h, valid=%b",
                         serial_out, valid);
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
        $dumpvars(0,clk, parallel_in, reset, serial_out, valid);
    end

endmodule
