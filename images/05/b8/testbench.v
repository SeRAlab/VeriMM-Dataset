`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg control;
    reg [63:0] data_in;
    reg reset;
    wire [63:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .control(control),
        .data_in(data_in),
        .reset(reset),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        control = 0;
        data_in = 64'b0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Basic Transmit...");
        test_num = test_num + 1;
        reset_dut();

        control = 1;
        data_in = 64'hAAAA_BBBB_CCCC_DDDD;
        @(posedge clk);
        #1;
        #1;

        check_outputs(64'hAAAA_BBBB_CCCC_DDDD);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Hold last received data...");
        test_num = test_num + 1;
        reset_dut();


        control = 1;
        data_in = 64'h1234_5678_90AB_CDEF;
        @(posedge clk);


        #1 control = 0;
        data_in = 64'hFFFF_FFFF_FFFF_FFFF;
        @(posedge clk);

        #1;
        #1;

        check_outputs(64'h1234_5678_90AB_CDEF);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Reset state behavior...");
        test_num = test_num + 1;
        reset_dut();

        control = 0;
        data_in = 64'h5555_5555_5555_5555;
        @(posedge clk);

        #1;
        #1;

        check_outputs(64'h0000_0000_0000_0000);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Multiple Mode Transitions...");
        test_num = test_num + 1;
        reset_dut();


        control = 1; data_in = 64'h0000_0000_0000_0001; @(posedge clk);
        #1 control = 0; data_in = 64'h0; @(posedge clk);


        #1 control = 1; data_in = 64'h0000_0000_0000_0002; @(posedge clk);
        #1 control = 0; data_in = 64'h0; @(posedge clk);


        #1;
        #1;

        check_outputs(64'h0000_0000_0000_0002);
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
        input [63:0] expected_data_out;
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
        $dumpvars(0,clk, control, data_in, reset, data_out);
    end

endmodule
