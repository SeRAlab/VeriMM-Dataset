`timescale 1ns/1ps

module ip_checksum_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] data_in;
    reg done;
    reg valid;
    wire [15:0] checksum;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ip_checksum dut (
        .data_in(data_in),
        .done(done),
        .valid(valid),
        .checksum(checksum),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        done = 0;
        forever #5 done = ~done;
    end

        task reset_dut;

    begin
        valid = 0;
        data_in = 16'h0;
        repeat(2) @(posedge done);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: Basic Sum (No Carry)");
        reset_dut();
        @(posedge done);
        valid = 1;
        data_in = 16'h1111; @(posedge done);
        data_in = 16'h2222; @(posedge done);
        valid = 0;
        wait(ready === 1);

        #1;


        check_outputs(16'hCCCC, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: Wrap-around Carry");
        reset_dut();
        @(posedge done);
        valid = 1;
        data_in = 16'hFFFF; @(posedge done);
        data_in = 16'h0001; @(posedge done);
        valid = 0;
        wait(ready === 1);

        #1;


        check_outputs(16'hFFFE, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: Result All Ones (Max Sum)");
        reset_dut();
        @(posedge done);
        valid = 1;
        data_in = 16'hFFFF; @(posedge done);
        data_in = 16'hFFFF; @(posedge done);
        valid = 0;
        wait(ready === 1);

        #1;


        check_outputs(16'h0000, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: All Zeros");
        reset_dut();
        @(posedge done);
        valid = 1;
        data_in = 16'h0000; @(posedge done);
        data_in = 16'h0000; @(posedge done);
        valid = 0;
        wait(ready === 1);

        #1;


        check_outputs(16'hFFFF, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Single Word Packet");
        reset_dut();
        @(posedge done);
        valid = 1;
        data_in = 16'h1234; @(posedge done);
        valid = 0;
        wait(ready === 1);

        #1;


        check_outputs(16'hEDCB, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: Standard IP Header Words");
        reset_dut();
        @(posedge done);
        valid = 1;
        data_in = 16'h4500; @(posedge done);
        data_in = 16'h003c; @(posedge done);
        data_in = 16'h1c46; @(posedge done);
        data_in = 16'h4000; @(posedge done);
        data_in = 16'h4006; @(posedge done);
        data_in = 16'h0000; @(posedge done);
        data_in = 16'hac10; @(posedge done);
        data_in = 16'h0a63; @(posedge done);
        data_in = 16'hac10; @(posedge done);
        data_in = 16'h0a0c; @(posedge done);
        valid = 0;
        wait(ready === 1);

        #1;


        check_outputs(16'hB1E6, 1'b1);
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
        input [15:0] expected_checksum;
        input expected_ready;
        begin
            if (expected_checksum === (expected_checksum ^ checksum ^ expected_checksum) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: checksum=%h, ready=%b",
                         checksum, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum=%h, ready=%b",
                         expected_checksum, expected_ready);
                $display("  Got:      checksum=%h, ready=%b",
                         checksum, ready);
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
        $dumpvars(0,data_in, done, valid, checksum, ready);
    end

endmodule
