`timescale 1ns/1ps

module ARQ_System_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg reset;
    reg valid;
    wire ack;
    wire [3:0] data_out;
    wire error;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ_System dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .valid(valid),
        .ack(ack),
        .data_out(data_out),
        .error(error)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 4'b0000;
            valid = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Initialization/Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 4'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Successful Transmit (Pattern 1010)", test_num);
            reset_dut();
            data_in = 4'b1010;
            valid = 1;
            @(posedge clk);
            valid = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 4'hA, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Successful Transmit (Pattern 1011)", test_num);
            reset_dut();
            data_in = 4'b1011;
            valid = 1;
            @(posedge clk);
            valid = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 4'hB, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Successful Transmit (Pattern 0000)", test_num);
            reset_dut();
            data_in = 4'b0000;
            valid = 1;
            @(posedge clk);
            valid = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 4'h0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Idle System (Valid = 0)", test_num);
            reset_dut();
            data_in = 4'b1111;
            valid = 0;
            repeat(3) @(posedge clk);

            #1;


            check_outputs(1'b0, 4'h0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ARQ_System Testbench");
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
        input expected_ack;
        input [3:0] expected_data_out;
        input expected_error;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_error === (expected_error ^ error ^ expected_error)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, data_out=%h, error=%b",
                         ack, data_out, error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, data_out=%h, error=%b",
                         expected_ack, expected_data_out, expected_error);
                $display("  Got:      ack=%b, data_out=%h, error=%b",
                         ack, data_out, error);
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
        $dumpvars(0,clk, data_in, reset, valid, ack, data_out, error);
    end

endmodule
