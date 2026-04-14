`timescale 1ns/1ps

module ip_checksum_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg data_valid;
    reg reset;
    wire [15:0] checksum_out;
    wire checksum_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ip_checksum dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .reset(reset),
        .checksum_out(checksum_out),
        .checksum_valid(checksum_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            #1 reset = 1;
            data_in = 16'h0;
            data_valid = 0;
            repeat (5) @(posedge clk);
            #1 reset = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros Block", test_num);
            reset_dut();
            @(posedge clk);
            #1 data_in = 16'h0000; data_valid = 1;
            @(posedge clk);
            #1 data_in = 16'h0000; data_valid = 1;
            @(posedge clk);
            #1 data_valid = 0;
            while (!checksum_valid) @(posedge clk);
            #1;

            check_outputs(16'hFFFF, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Addition (No Carry)", test_num);
            reset_dut();
            @(posedge clk);
            #1 data_in = 16'h1234; data_valid = 1;
            @(posedge clk);
            #1 data_in = 16'h5678; data_valid = 1;
            @(posedge clk);
            #1 data_valid = 0;
            while (!checksum_valid) @(posedge clk);
            #1;

            check_outputs(16'h9753, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Carry Wraparound", test_num);
            reset_dut();
            @(posedge clk);
            #1 data_in = 16'hFFFF; data_valid = 1;
            @(posedge clk);
            #1 data_in = 16'h0001; data_valid = 1;
            @(posedge clk);
            #1 data_valid = 0;
            while (!checksum_valid) @(posedge clk);
            #1;

            check_outputs(16'hFFFE, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: RFC 1071 Example", test_num);
            reset_dut();
            @(posedge clk);
            #1 data_in = 16'h0001; data_valid = 1;
            @(posedge clk);
            #1 data_in = 16'hf203; data_valid = 1;
            @(posedge clk);
            #1 data_in = 16'hf4f5; data_valid = 1;
            @(posedge clk);
            #1 data_in = 16'hf6f7; data_valid = 1;
            @(posedge clk);
            #1 data_valid = 0;
            while (!checksum_valid) @(posedge clk);
            #1;

            check_outputs(16'h210F, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Double Maximum Value", test_num);
            reset_dut();
            @(posedge clk);
            #1 data_in = 16'hFFFF; data_valid = 1;
            @(posedge clk);
            #1 data_in = 16'hFFFF; data_valid = 1;
            @(posedge clk);
            #1 data_valid = 0;
            while (!checksum_valid) @(posedge clk);
            #1;

            check_outputs(16'h0000, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Word Block", test_num);
            reset_dut();
            @(posedge clk);
            #1 data_in = 16'hAAAA; data_valid = 1;
            @(posedge clk);
            #1 data_valid = 0;
            while (!checksum_valid) @(posedge clk);
            #1;

            check_outputs(16'h5555, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ip_checksum Testbench");
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
        input [15:0] expected_checksum_out;
        input expected_checksum_valid;
        begin
            if (expected_checksum_out === (expected_checksum_out ^ checksum_out ^ expected_checksum_out) &&
                expected_checksum_valid === (expected_checksum_valid ^ checksum_valid ^ expected_checksum_valid)) begin
                $display("PASS");
                $display("  Outputs: checksum_out=%h, checksum_valid=%b",
                         checksum_out, checksum_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum_out=%h, checksum_valid=%b",
                         expected_checksum_out, expected_checksum_valid);
                $display("  Got:      checksum_out=%h, checksum_valid=%b",
                         checksum_out, checksum_valid);
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
        $dumpvars(0,clk, data_in, data_valid, reset, checksum_out, checksum_valid);
    end

endmodule
