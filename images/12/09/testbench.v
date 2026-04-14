`timescale 1ns/1ps

module serializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg enable;
    reg start;
    wire done;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    serializer dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .start(start),
        .done(done),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start = 1'b0;
            enable = 1'b0;
            data_in = 32'h0;

            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase %0d: All Ones (0xFFFFFFFF)", test_num);
            data_in = 32'hFFFFFFFF;
            start = 1'b1;
            enable = 1'b1;
            @(posedge clk);
            #1 start = 1'b0;


            repeat(31) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase %0d: All Zeros (0x00000000)", test_num);
            data_in = 32'h00000000;
            start = 1'b1;
            enable = 1'b1;
            @(posedge clk);
            #1 start = 1'b0;

            repeat(31) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase %0d: Alternating Bits (0xAAAAAAAA)", test_num);
            data_in = 32'hAAAAAAAA;
            start = 1'b1;
            enable = 1'b1;
            @(posedge clk);
            #1 start = 1'b0;

            repeat(31) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase %0d: Alternating Bits (0x55555555)", test_num);
            data_in = 32'h55555555;
            start = 1'b1;
            enable = 1'b1;
            @(posedge clk);
            #1 start = 1'b0;

            repeat(31) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Running Testcase %0d: Mixed Pattern (0x12345678)", test_num);
            data_in = 32'h12345678;
            start = 1'b1;
            enable = 1'b1;
            @(posedge clk);
            #1 start = 1'b0;

            repeat(31) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0);
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
        input expected_done;
        input expected_serial_out;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: done=%b, serial_out=%b",
                         done, serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, serial_out=%b",
                         expected_done, expected_serial_out);
                $display("  Got:      done=%b, serial_out=%b",
                         done, serial_out);
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
        $dumpvars(0,clk, data_in, enable, start, done, serial_out);
    end

endmodule
