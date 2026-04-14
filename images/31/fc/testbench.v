`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg data_valid;
    reg reset;
    wire frame_received;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .reset(reset),
        .frame_received(frame_received)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        data_in = 8'h0;
        data_valid = 0;
        repeat(2) @(posedge clk);
        reset = 0;
        @(posedge clk);
    end
        endtask
    task send_byte;

        input [7:0] b;
        begin
            data_in = b;
            data_valid = 1;
            @(posedge clk);
        end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Standard Frame Reception", test_num);
        reset_dut();


        repeat(7) send_byte(8'h55);

        send_byte(8'hD5);

        repeat(10) send_byte($random);

        data_valid = 0;
        data_in = 0;
        @(posedge clk);


        #1;



        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Fragmented Frame (No SFD)", test_num);
        reset_dut();


        repeat(5) send_byte(8'h55);

        data_valid = 0;
        @(posedge clk);

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Back-to-Back Frame Reception", test_num);
        reset_dut();


        repeat(4) send_byte(8'h55);
        send_byte(8'hD5);
        repeat(4) send_byte(8'hAA);
        data_valid = 0;
        @(posedge clk);


        repeat(5) @(posedge clk);


        repeat(4) send_byte(8'h55);
        send_byte(8'hD5);
        repeat(4) send_byte(8'hBB);
        data_valid = 0;
        @(posedge clk);

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset During Transmission", test_num);
        reset_dut();

        send_byte(8'h55);
        send_byte(8'hD5);
        send_byte(8'hEE);


        reset = 1;
        @(posedge clk);
        reset = 0;
        data_valid = 0;
        repeat(2) @(posedge clk);

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
        input expected_frame_received;
        begin
            if (expected_frame_received === (expected_frame_received ^ frame_received ^ expected_frame_received)) begin
                $display("PASS");
                $display("  Outputs: frame_received=%b",
                         frame_received);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frame_received=%b",
                         expected_frame_received);
                $display("  Got:      frame_received=%b",
                         frame_received);
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
        $dumpvars(0,clk, data_in, data_valid, reset, frame_received);
    end

endmodule
