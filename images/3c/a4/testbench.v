`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [47:0] dest_addr;
    reg frame_received;
    reg reset;
    wire [7:0] frame_counter;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .dest_addr(dest_addr),
        .frame_received(frame_received),
        .reset(reset),
        .frame_counter(frame_counter)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        dest_addr = 0;
        frame_received = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Initial Reset Verification", test_num);
        reset_dut();
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Single Matching Frame", test_num);
        reset_dut();
        @(negedge clk);
        dest_addr = MATCH_ADDR;
        frame_received = 1;
        @(negedge clk);
        frame_received = 0;
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Single Non-Matching Frame", test_num);
        reset_dut();
        @(negedge clk);
        dest_addr = WRONG_ADDR;
        frame_received = 1;
        @(negedge clk);
        frame_received = 0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Multiple Matching Frames", test_num);
        reset_dut();

        @(negedge clk);
        dest_addr = MATCH_ADDR;
        frame_received = 1;
        @(negedge clk);
        frame_received = 0;

        @(negedge clk);
        dest_addr = MATCH_ADDR;
        frame_received = 1;
        @(negedge clk);
        frame_received = 0;

        @(negedge clk);
        dest_addr = MATCH_ADDR;
        frame_received = 1;
        @(negedge clk);
        frame_received = 0;
        #1;

        check_outputs(8'd3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Mixed Address Frames", test_num);
        reset_dut();

        @(negedge clk);
        dest_addr = MATCH_ADDR;
        frame_received = 1;
        @(negedge clk);

        dest_addr = WRONG_ADDR;
        frame_received = 1;
        @(negedge clk);

        dest_addr = MATCH_ADDR;
        frame_received = 1;
        @(negedge clk);
        frame_received = 0;
        #1;

        check_outputs(8'd2);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Mid-Operation Reset", test_num);
        reset_dut();
        @(negedge clk);
        dest_addr = MATCH_ADDR;
        frame_received = 1;
        @(negedge clk);
        @(negedge clk);
        reset = 1;
        @(negedge clk);
        reset = 0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ethernet_mac_controller Testbench");
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
        input [7:0] expected_frame_counter;
        begin
            if (expected_frame_counter === (expected_frame_counter ^ frame_counter ^ expected_frame_counter)) begin
                $display("PASS");
                $display("  Outputs: frame_counter=%h",
                         frame_counter);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frame_counter=%h",
                         expected_frame_counter);
                $display("  Got:      frame_counter=%h",
                         frame_counter);
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
        $dumpvars(0,clk, dest_addr, frame_received, reset, frame_counter);
    end

endmodule
