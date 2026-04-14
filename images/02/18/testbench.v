`timescale 1ns/1ps

module serializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] parallel_in;
    reg reset;
    reg start;
    wire serial_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    serializer dut (
        .clk(clk),
        .parallel_in(parallel_in),
        .reset(reset),
        .start(start),
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
            @(posedge clk);
            reset = 1;
            start = 0;
            parallel_in = 32'b0;
            repeat (2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        reg [31:0] data;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: All ones (0xFFFFFFFF)", test_num);
            reset_dut();

            data = 32'hFFFFFFFF;
            parallel_in = data;
            start = 1;
            @(posedge clk);
            start = 0;

            for (i = 0; i < 32; i = i + 1) begin

                #1;


                check_outputs(data[31-i], 1'b1);
                @(posedge clk);
            end


            #1;



            check_outputs(serial_out, 1'b0);
        end
        endtask

    task testcase002;

        reg [31:0] data;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Alternating bits (0xAAAAAAAA)", test_num);
            reset_dut();

            data = 32'hAAAAAAAA;
            parallel_in = data;
            start = 1;
            @(posedge clk);
            start = 0;

            for (i = 0; i < 32; i = i + 1) begin
                #1;

                check_outputs(data[31-i], 1'b1);
                @(posedge clk);
            end
            #1;

            check_outputs(serial_out, 1'b0);
        end
        endtask

    task testcase003;

        reg [31:0] data;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Single bit (0x00000001)", test_num);
            reset_dut();

            data = 32'h00000001;
            parallel_in = data;
            start = 1;
            @(posedge clk);
            start = 0;

            for (i = 0; i < 32; i = i + 1) begin
                #1;

                check_outputs(data[31-i], 1'b1);
                @(posedge clk);
            end
            #1;

            check_outputs(serial_out, 1'b0);
        end
        endtask

    task testcase004;

        reg [31:0] data;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Hex sequence (0x12345678)", test_num);
            reset_dut();

            data = 32'h12345678;
            parallel_in = data;
            start = 1;
            @(posedge clk);
            start = 0;

            for (i = 0; i < 32; i = i + 1) begin
                #1;

                check_outputs(data[31-i], 1'b1);
                @(posedge clk);
            end
            #1;

            check_outputs(serial_out, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Idle state check", test_num);
            reset_dut();
            repeat(5) @(posedge clk);

            #1;


            check_outputs(serial_out, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("serializer Testbench");
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
        input expected_serial_out;
        input expected_valid;
        begin
            if (expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: serial_out=%b, valid=%b",
                         serial_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: serial_out=%b, valid=%b",
                         expected_serial_out, expected_valid);
                $display("  Got:      serial_out=%b, valid=%b",
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
        $dumpvars(0,clk, parallel_in, reset, start, serial_out, valid);
    end

endmodule
