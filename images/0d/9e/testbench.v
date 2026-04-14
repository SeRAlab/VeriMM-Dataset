`timescale 1ns/1ps

module ARQ_Sender_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg nack_in;
    reg reset;
    wire ack_out;
    wire data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ_Sender dut (
        .clk(clk),
        .data_in(data_in),
        .nack_in(nack_in),
        .reset(reset),
        .ack_out(ack_out),
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
        data_in = 0;
        nack_in = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Checking Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Successful transmission of '1'", test_num);
        reset_dut();
        data_in = 1;
        nack_in = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Successful transmission of '0'", test_num);
        reset_dut();
        data_in = 0;
        nack_in = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Failed transmission with NACK", test_num);
        reset_dut();
        data_in = 1;
        nack_in = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Retransmission sequence", test_num);
        reset_dut();


        data_in = 1;
        nack_in = 1;
        @(posedge clk);


        #1 nack_in = 0;
        @(posedge clk);
        #1;


        #1;



        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Sustained NACK for multiple cycles", test_num);
        reset_dut();
        data_in = 1;
        nack_in = 1;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Sequence of alternating data bits", test_num);
        reset_dut();


        data_in = 1; nack_in = 0;
        @(posedge clk);


        #1 data_in = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ARQ_Sender Testbench");
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
        input expected_ack_out;
        input expected_data_out;
        begin
            if (expected_ack_out === (expected_ack_out ^ ack_out ^ expected_ack_out) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: ack_out=%b, data_out=%b",
                         ack_out, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_out=%b, data_out=%b",
                         expected_ack_out, expected_data_out);
                $display("  Got:      ack_out=%b, data_out=%b",
                         ack_out, data_out);
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
        $dumpvars(0,clk, data_in, nack_in, reset, ack_out, data_out);
    end

endmodule
