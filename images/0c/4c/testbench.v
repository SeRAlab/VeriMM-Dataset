`timescale 1ns/1ps

module ARQ_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg [4:0] data_in;
    wire [4:0] data_out;
    wire send;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ dut (
        .ack(ack),
        .data_in(data_in),
        .data_out(data_out),
        .send(send)
    );

    // Clock generation (10ns period)
    initial begin
        ack = 0;
        forever #5 ack = ~ack;
    end

        task reset_dut;

    begin
        data_in = 5'b0;
        @(negedge ack);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Transmission (ACK=1)", test_num);
        reset_dut();
        data_in = 5'h0A;
        @(posedge ack);
        #2;
        #1;

        check_outputs(5'h0A, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Hold (ACK=0)", test_num);
        reset_dut();
        data_in = 5'h15;
        @(negedge ack);
        #2;
        #1;

        check_outputs(5'h00, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Hold Persistence", test_num);
        reset_dut();

        data_in = 5'h05;
        @(posedge ack);
        #1;

        @(negedge ack);
        data_in = 5'h1F;
        #2;

        #1;


        check_outputs(5'h05, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Recovery after NACK", test_num);
        reset_dut();

        data_in = 5'h12;
        @(posedge ack);

        @(negedge ack);
        data_in = 5'h09;

        @(posedge ack);
        #2;
        #1;

        check_outputs(5'h09, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All Bits Toggle (5'h1F)", test_num);
        reset_dut();
        data_in = 5'h1F;
        @(posedge ack);
        #2;
        #1;

        check_outputs(5'h1F, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ARQ Testbench");
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
        input [4:0] expected_data_out;
        input expected_send;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_send === (expected_send ^ send ^ expected_send)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, send=%b",
                         data_out, send);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, send=%b",
                         expected_data_out, expected_send);
                $display("  Got:      data_out=%h, send=%b",
                         data_out, send);
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
        $dumpvars(0,ack, data_in, data_out, send);
    end

endmodule
