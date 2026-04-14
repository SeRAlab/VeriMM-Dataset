`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] frame_data;
    reg frame_valid;
    reg reset;
    wire frame_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .frame_data(frame_data),
        .frame_valid(frame_valid),
        .reset(reset),
        .frame_ready(frame_ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        frame_data = 8'h00;
        frame_valid = 0;
        repeat(2) @(posedge clk);
        #1 reset = 0;
        repeat(1) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase %0d: Send full 4-byte frame...", test_num);
        reset_dut();

        @(posedge clk);
        frame_valid = 1;
        frame_data = 8'hAA; @(posedge clk);
        frame_data = 8'hBB; @(posedge clk);
        frame_data = 8'hCC; @(posedge clk);
        frame_data = 8'hDD; @(posedge clk);
        frame_valid = 0;


        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase %0d: Send incomplete 2-byte frame...", test_num);
        reset_dut();

        @(posedge clk);
        frame_valid = 1;
        frame_data = 8'h11; @(posedge clk);
        frame_data = 8'h22; @(posedge clk);
        frame_valid = 0;

        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase %0d: Reset mid-transmission...", test_num);
        reset_dut();

        @(posedge clk);
        frame_valid = 1;
        frame_data = 8'h01; @(posedge clk);
        frame_data = 8'h02; @(posedge clk);


        reset = 1;
        @(posedge clk);
        reset = 0;
        frame_valid = 0;

        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase %0d: Send two consecutive valid frames...", test_num);
        reset_dut();


        @(posedge clk);
        frame_valid = 1;
        frame_data = 8'h11; @(posedge clk);
        frame_data = 8'h22; @(posedge clk);
        frame_data = 8'h33; @(posedge clk);
        frame_data = 8'h44; @(posedge clk);
        frame_valid = 0;
        repeat(2) @(posedge clk);


        frame_valid = 1;
        frame_data = 8'h55; @(posedge clk);
        frame_data = 8'h66; @(posedge clk);
        frame_data = 8'h77; @(posedge clk);
        frame_data = 8'h88; @(posedge clk);
        frame_valid = 0;

        #1;
        #1;

        check_outputs(1'b1);
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
        input expected_frame_ready;
        begin
            if (expected_frame_ready === (expected_frame_ready ^ frame_ready ^ expected_frame_ready)) begin
                $display("PASS");
                $display("  Outputs: frame_ready=%b",
                         frame_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frame_ready=%b",
                         expected_frame_ready);
                $display("  Got:      frame_ready=%b",
                         frame_ready);
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
        $dumpvars(0,clk, frame_data, frame_valid, reset, frame_ready);
    end

endmodule
