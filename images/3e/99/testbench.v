`timescale 1ns/1ps

module bluetooth_packet_checker_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] packet;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bluetooth_packet_checker dut (
        .clk(clk),
        .packet(packet),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        packet = 8'h00;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Running Testcase 001: Standard Valid Packet...");
        packet <= 8'hAA; @(posedge clk);
        packet <= 8'h55; @(posedge clk);
        packet <= 8'hCC; @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Running Testcase 002: Invalid Start Byte...");
        packet <= 8'h00; @(posedge clk);
        packet <= 8'h55; @(posedge clk);
        packet <= 8'hCC; @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Running Testcase 003: Invalid End Byte...");
        packet <= 8'hAA; @(posedge clk);
        packet <= 8'h55; @(posedge clk);
        packet <= 8'hFF; @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Running Testcase 004: Minimal Valid Packet (No Payload)...");
        packet <= 8'hAA; @(posedge clk);
        packet <= 8'hCC; @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Running Testcase 005: Long Valid Packet...");
        packet <= 8'hAA; @(posedge clk);
        packet <= 8'h11; @(posedge clk);
        packet <= 8'h22; @(posedge clk);
        packet <= 8'h33; @(posedge clk);
        packet <= 8'h44; @(posedge clk);
        packet <= 8'hCC; @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Running Testcase 006: Multiple Start Bytes...");
        packet <= 8'hAA; @(posedge clk);
        packet <= 8'hAA; @(posedge clk);
        packet <= 8'h11; @(posedge clk);
        packet <= 8'hCC; @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Running Testcase 007: Interrupted by Mid-Packet Reset...");
        packet <= 8'hAA; @(posedge clk);
        packet <= 8'h11; @(posedge clk);
        rst = 1; @(posedge clk); rst = 0;
        packet <= 8'hCC; @(posedge clk);
        #2;
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
        $display("bluetooth_packet_checker Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input expected_valid;
        begin
            if (expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: valid=%b",
                         valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: valid=%b",
                         expected_valid);
                $display("  Got:      valid=%b",
                         valid);
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
        $dumpvars(0,clk, packet, valid);
    end

endmodule
