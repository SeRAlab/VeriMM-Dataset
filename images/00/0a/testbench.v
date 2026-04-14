`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg direction;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .direction(direction),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        integer i;
        begin
            direction = 0;
            data_in = 16'h0000;

            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk);
            end
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift Left (4 cycles)", test_num);
            reset_dut();

            @(posedge clk); direction = 0; data_in = 16'h0001;
            @(posedge clk); direction = 0; data_in = 16'h0001;
            @(posedge clk); direction = 0; data_in = 16'h0000;
            @(posedge clk); direction = 0; data_in = 16'h0000;

            #1; #1;
 check_outputs(16'h000C);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift Right (4 cycles)", test_num);
            reset_dut();

            @(posedge clk); direction = 1; data_in = 16'h8000;
            @(posedge clk); direction = 1; data_in = 16'h8000;
            @(posedge clk); direction = 1; data_in = 16'h0000;
            @(posedge clk); direction = 1; data_in = 16'h0000;

            #1; #1;
 check_outputs(16'h3000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Direction Toggle", test_num);
            reset_dut();

            @(posedge clk); direction = 0; data_in = 16'h0001;
            @(posedge clk); direction = 0; data_in = 16'h0001;
            @(posedge clk); direction = 1; data_in = 16'h0000;

            #1; #1;
 check_outputs(16'h0001);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Fill All and Overflow", test_num);
            reset_dut();

            direction = 0;
            data_in = 16'hFFFF;
            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk);
            end

            @(posedge clk); data_in = 16'h0000;

            #1; #1;
 check_outputs(16'hFFFE);
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
        input [15:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, direction, data_out);
    end

endmodule
