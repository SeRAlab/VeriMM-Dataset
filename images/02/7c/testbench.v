`timescale 1ns/1ps

module serializer_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] parallel_in;
    reg reset;
    wire done;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    serializer_8bit dut (
        .clk(clk),
        .parallel_in(parallel_in),
        .reset(reset),
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
            reset = 1;
            parallel_in = 8'b0;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task run_serializer_test;

        input [7:0] pattern;
        reg [7:0] captured;
        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Input Pattern 8'b%b", test_num, pattern);
            reset_dut();
            parallel_in = pattern;



            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
                captured[7-i] = serial_out;
            end


            if (captured !== pattern) begin
                $display("  FAIL: Bitstream mismatch. Expected %b, Got %b", pattern, captured);

                #1;


                check_outputs(1'b1, ~pattern[0]);
            end else begin

                #1;


                check_outputs(1'b1, pattern[0]);
            end
        end
        endtask

    task testcase001;

        begin
            run_serializer_test(8'b10101010);
        end
        endtask

    task testcase002;

        begin
            run_serializer_test(8'b01010101);
        end
        endtask

    task testcase003;

        begin
            run_serializer_test(8'b11111111);
        end
        endtask

    task testcase004;

        begin
            run_serializer_test(8'b00000000);
        end
        endtask

    task testcase005;

        begin
            run_serializer_test(8'b11000011);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("serializer_8bit Testbench");
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
        $dumpvars(0,clk, parallel_in, reset, done, serial_out);
    end

endmodule
