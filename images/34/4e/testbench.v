`timescale 1ns/1ps

module deserializer_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg serial_in;
    wire [31:0] parallel_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deserializer_32bit dut (
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
            serial_in = 4'b0;
            @(posedge clk);
            #2 reset = 0;

            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequential Nibbles", test_num);
            reset_dut();

            serial_in = 4'h1; @(posedge clk);
            serial_in = 4'h2; @(posedge clk);
            serial_in = 4'h3; @(posedge clk);
            serial_in = 4'h4; @(posedge clk);
            serial_in = 4'h5; @(posedge clk);
            serial_in = 4'h6; @(posedge clk);
            serial_in = 4'h7; @(posedge clk);
            serial_in = 4'h8; @(posedge clk);

            #1;
            #1;

            check_outputs(32'h12345678, 1'b1);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                serial_in = 4'hF;
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(32'hFFFFFFFF, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Patterns", test_num);
            reset_dut();
            for (i = 0; i < 4; i = i + 1) begin
                serial_in = 4'hA; @(posedge clk);
                serial_in = 4'h5; @(posedge clk);
            end
            #1;
            #1;

            check_outputs(32'hA5A5A5A5, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                serial_in = 4'h0;
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: DEADBEEF", test_num);
            reset_dut();
            serial_in = 4'hD; @(posedge clk);
            serial_in = 4'hE; @(posedge clk);
            serial_in = 4'hA; @(posedge clk);
            serial_in = 4'hD; @(posedge clk);
            serial_in = 4'hB; @(posedge clk);
            serial_in = 4'hE; @(posedge clk);
            serial_in = 4'hE; @(posedge clk);
            serial_in = 4'hF; @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEADBEEF, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deserializer_32bit Testbench");
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
        input [31:0] expected_parallel_out;
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
