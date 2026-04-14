`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg serial_in;
    wire [3:0] shift_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .enable(enable),
        .serial_in(serial_in),
        .shift_out(shift_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        enable = 1'b1;
        serial_in = 1'b0;
        repeat(4) @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Shift in 1011", test_num);
        reset_dut();

        @(posedge clk) begin enable = 1; serial_in = 1; end
        @(posedge clk) begin enable = 1; serial_in = 0; end
        @(posedge clk) begin enable = 1; serial_in = 1; end
        @(posedge clk) begin enable = 1; serial_in = 1; end

        #1;
        #1;

        check_outputs(4'b1011);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Shift in 1111", test_num);
        reset_dut();

        repeat(4) @(posedge clk) begin
            enable = 1;
            serial_in = 1;
        end

        #1;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Verify Enable Logic", test_num);
        reset_dut();

        @(posedge clk) begin enable = 1; serial_in = 1; end
        @(posedge clk) begin enable = 0; serial_in = 0; end
        @(posedge clk) begin enable = 0; serial_in = 1; end
        @(posedge clk) begin enable = 1; serial_in = 0; end
        @(posedge clk) begin enable = 1; serial_in = 1; end
        @(posedge clk) begin enable = 1; serial_in = 1; end

        #1;
        #1;

        check_outputs(4'b1011);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Overflow Test (5 bits)", test_num);
        reset_dut();

        @(posedge clk) begin enable = 1; serial_in = 1; end
        @(posedge clk) begin enable = 1; serial_in = 0; end
        @(posedge clk) begin enable = 1; serial_in = 1; end
        @(posedge clk) begin enable = 1; serial_in = 1; end
        @(posedge clk) begin enable = 1; serial_in = 0; end

        #1;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Shift in all zeros", test_num);
        reset_dut();


        #1;



        check_outputs(4'b0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
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
        input [3:0] expected_shift_out;
        begin
            if (expected_shift_out === (expected_shift_out ^ shift_out ^ expected_shift_out)) begin
                $display("PASS");
                $display("  Outputs: shift_out=%h",
                         shift_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shift_out=%h",
                         expected_shift_out);
                $display("  Got:      shift_out=%h",
                         shift_out);
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
        $dumpvars(0,clk, enable, serial_in, shift_out);
    end

endmodule
