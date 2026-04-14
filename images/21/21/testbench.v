`timescale 1ns/1ps

module serializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] parallel_in;
    reg reset;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    serializer dut (
        .clk(clk),
        .parallel_in(parallel_in),
        .reset(reset),
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
            @(posedge clk);
            #1;
            reset = 0;


            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Check MSB (Bit 7) immediately after load/reset", test_num);
            parallel_in = 8'b11001010;
            reset = 1; @(posedge clk); #1; reset = 0;
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Check Bit 6 after 1 clock shift", test_num);
            parallel_in = 8'b11001010;
            reset = 1; @(posedge clk); #1; reset = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Check Bit 5 after 2 clock shifts", test_num);
            parallel_in = 8'b11001010;
            reset = 1; @(posedge clk); #1; reset = 0;
            repeat(2) @(posedge clk); #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Check Bit 4 after 3 clock shifts", test_num);
            parallel_in = 8'b11001010;
            reset = 1; @(posedge clk); #1; reset = 0;
            repeat(3) @(posedge clk); #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Check Bit 3 after 4 clock shifts", test_num);
            parallel_in = 8'b11001010;
            reset = 1; @(posedge clk); #1; reset = 0;
            repeat(4) @(posedge clk); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Check Bit 2 after 5 clock shifts", test_num);
            parallel_in = 8'b11001010;
            reset = 1; @(posedge clk); #1; reset = 0;
            repeat(5) @(posedge clk); #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Check Bit 1 after 6 clock shifts", test_num);
            parallel_in = 8'b11001010;
            reset = 1; @(posedge clk); #1; reset = 0;
            repeat(6) @(posedge clk); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Check LSB (Bit 0) after 7 clock shifts", test_num);
            parallel_in = 8'b11001010;
            reset = 1; @(posedge clk); #1; reset = 0;
            repeat(7) @(posedge clk); #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All ones pattern check mid-sequence", test_num);
            parallel_in = 8'b11111111;
            reset = 1; @(posedge clk); #1; reset = 0;
            repeat(4) @(posedge clk); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All zeros pattern check mid-sequence", test_num);
            parallel_in = 8'b00000000;
            reset = 1; @(posedge clk); #1; reset = 0;
            repeat(4) @(posedge clk); #1;
            #1;

            check_outputs(1'b0);
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
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        begin
            if (expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: serial_out=%b",
                         serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: serial_out=%b",
                         expected_serial_out);
                $display("  Got:      serial_out=%b",
                         serial_out);
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
        $dumpvars(0,clk, parallel_in, reset, serial_out);
    end

endmodule
